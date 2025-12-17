import os
from typing import Dict

import cv2
import joblib
import numpy as np
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import HTMLResponse, JSONResponse
from skimage.feature import graycomatrix, hog

# =========================================================
# KONFIGURASI
# =========================================================

IMG_SIZE = (100, 100)

# Urutan kelas harus sama dengan SELECTED_CLASSES / class_to_idx di notebook
IDX_TO_CLASS: Dict[int, str] = {
    0: "Tomato",
    1: "Onion White",
    2: "Pepper Green",
    3: "Cucumber Ripe",
    4: "Corn",
    5: "Pepper Red",
}

# File model SVM pipeline jalur 1 (hasil joblib.dump di notebook)
MODEL_PATH = os.getenv("MODEL_PATH", "SVM_RBF_X1.pkl")
SCALER_PATH = os.getenv("SCALER_PATH", "scaler_X1.pkl")  # hanya untuk tugas
PCA_PATH = os.getenv("PCA_PATH", "pca_hog1.pkl")        # 🔹 PCA HOG jalur 1

app = FastAPI(title="Jawara Veggie Classifier - SVM Jalur 1")

# =========================================================
# FUNGSI PREPROCESSING (SAMA DENGAN NOTEBOOK)
# =========================================================

def preprocess_image_gray_pipeline(img_bgr, size=(100, 100)):
    """Preprocessing 1: blur → grayscale → Otsu → morphology (gray pipeline)."""
    img_resized = cv2.resize(img_bgr, size)
    blurred = cv2.GaussianBlur(img_resized, (3, 3), 0.2)
    gray = cv2.cvtColor(blurred, cv2.COLOR_BGR2GRAY)

    _, binary = cv2.threshold(
        gray, 0, 255,
        cv2.THRESH_BINARY + cv2.THRESH_OTSU
    )

    kernel = np.ones((3, 3), np.uint8)
    closed = cv2.morphologyEx(binary, cv2.MORPH_CLOSE, kernel, iterations=2)
    cleaned = cv2.morphologyEx(closed, cv2.MORPH_OPEN, kernel, iterations=1)

    return gray, binary, cleaned


def preprocess_image_color_pipeline(img_bgr, ksize=(5, 5)):
    """
    Preprocessing 2 (keep color object) – dipakai untuk mask / ROI.
    """
    img_resized = cv2.resize(img_bgr, IMG_SIZE)
    blurred = cv2.GaussianBlur(img_resized, ksize, 0)
    hsv = cv2.cvtColor(blurred, cv2.COLOR_BGR2HSV)
    _, _, v = cv2.split(hsv)

    _, binary_inv = cv2.threshold(
        v, 0, 255,
        cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU
    )

    kernel = np.ones((3, 3), np.uint8)
    mask = cv2.morphologyEx(binary_inv, cv2.MORPH_OPEN, kernel, iterations=1)
    mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, kernel, iterations=1)

    color_masked = cv2.bitwise_and(blurred, blurred, mask=mask)
    return blurred, hsv, binary_inv, mask, color_masked


def get_object_roi(img, mask, pad=3):
    """Ambil bounding box objek dari mask (0/255)."""
    ys, xs = np.where(mask > 0)
    if len(xs) == 0 or len(ys) == 0:
        return img

    x_min, x_max = xs.min(), xs.max()
    y_min, y_max = ys.min(), ys.max()

    h, w = mask.shape[:2]
    x_min = max(x_min - pad, 0)
    y_min = max(y_min - pad, 0)
    x_max = min(x_max + pad, w - 1)
    y_max = min(y_max + pad, h - 1)

    return img[y_min:y_max + 1, x_min:x_max + 1]


def _quantize_gray(image, levels=64):
    """Quantize grayscale ke [0, levels-1] untuk GLCM."""
    image = image.astype(np.float32)
    img_min = float(image.min())
    img_max = float(image.max())

    if img_max - img_min < 1e-6:
        return np.zeros_like(image, dtype=np.uint8)

    norm = (image - img_min) / (img_max - img_min)
    q = (norm * (levels - 1)).round().astype(np.uint8)
    return q


def _haralick_from_glcm(P):
    """
    Hitung 13 fitur Haralick dari satu matriks GLCM (copy dari notebook).
    """
    eps = 1e-12
    P = P.astype(np.float64)
    P = P / (P.sum() + eps)

    Ng = P.shape[0]
    i_idx, j_idx = np.indices((Ng, Ng))

    px = P.sum(axis=1)
    py = P.sum(axis=0)

    ux = (i_idx[:, 0] * px).sum()
    uy = (j_idx[0, :] * py).sum()
    sigx = np.sqrt(((i_idx[:, 0] - ux) ** 2 * px).sum() + eps)
    sigy = np.sqrt(((j_idx[0, :] - uy) ** 2 * py).sum() + eps)

    asm = (P ** 2).sum()
    energy = asm
    contrast = (((i_idx - j_idx) ** 2) * P).sum()
    correlation = (((i_idx * j_idx) * P).sum() - ux * uy) / (sigx * sigy)
    variance = (((i_idx[:, 0] - ux) ** 2) * px).sum()
    homogeneity = (P / (1.0 + (i_idx - j_idx) ** 2)).sum()
    entropy = -(P[P > 0] * np.log2(P[P > 0])).sum()

    # p_sum (i+j = k)
    p_sum = np.zeros(2 * Ng - 1)
    for i in range(Ng):
        for j in range(Ng):
            p_sum[i + j] += P[i, j]

    k = np.arange(2 * Ng - 1)
    sum_avg = (k * p_sum).sum()

    p_sum_nz = p_sum[p_sum > 0]
    sum_entropy = -(p_sum_nz * np.log2(p_sum_nz)).sum()
    sum_var = (((k - sum_entropy) ** 2) * p_sum).sum()

    # p_diff (|i-j| = k)
    p_diff = np.zeros(Ng)
    for i in range(Ng):
        for j in range(Ng):
            p_diff[abs(i - j)] += P[i, j]

    p_diff_nz = p_diff[p_diff > 0]
    diff_entropy = -(p_diff_nz * np.log2(p_diff_nz)).sum()

    Hx = -(px[px > 0] * np.log2(px[px > 0])).sum()
    Hy = -(py[py > 0] * np.log2(py[py > 0])).sum()
    Hxy = entropy
    Hxy1 = -(P * np.log2(px[:, None] * py[None, :] + eps)).sum()
    Hxy2 = -(px[:, None] * py[None, :] *
             np.log2(px[:, None] * py[None, :] + eps)).sum()

    imc1 = (Hxy - Hxy1) / max(Hx, Hy)
    imc2 = np.sqrt(1 - np.exp(-2.0 * (Hxy2 - Hxy)))

    Q = np.zeros_like(P)
    for i in range(Ng):
        for j in range(Ng):
            if px[i] > 0 and py[j] > 0:
                Q[i, j] = P[i, j] / np.sqrt(px[i] * py[j])
    vals = np.linalg.eigvals(Q.T @ Q)
    vals_sorted = np.sort(np.real(vals))
    mcc = np.sqrt(vals_sorted[-2]) if len(vals_sorted) >= 2 else 0.0

    return np.array([
        energy, contrast, correlation, variance, homogeneity,
        sum_avg, sum_var, sum_entropy, entropy, diff_entropy,
        imc1, imc2, mcc
    ], dtype=np.float32)


def compute_glcm_haralick_features(gray, mask=None,
                                   distances=(1, 2, 3),
                                   angles=(0, np.pi/4, np.pi/2, 3*np.pi/4),
                                   levels=64):
    """Hitung rata-rata 13 fitur Haralick dari beberapa GLCM."""
    gray = gray.copy()
    if mask is not None:
        gray = gray.astype(np.float32)
        gray[mask == 0] = 0

    q = _quantize_gray(gray, levels=levels)

    glcm = graycomatrix(
        q,
        distances=distances,
        angles=angles,
        levels=levels,
        symmetric=True,
        normed=True
    )

    feats_all = []
    for d_idx in range(len(distances)):
        for a_idx in range(len(angles)):
            P = glcm[:, :, d_idx, a_idx]
            feats_all.append(_haralick_from_glcm(P))

    feats_all = np.stack(feats_all, axis=0)
    return feats_all.mean(axis=0)


def extract_hog_features(gray_roi,
                         resize_to=(100, 100),
                         orientations=9,
                         pixels_per_cell=(8, 8),
                         cells_per_block=(2, 2)):
    """Ekstraksi fitur HOG seperti di notebook."""
    if gray_roi.ndim == 3:
        gray_roi = cv2.cvtColor(gray_roi, cv2.COLOR_BGR2GRAY)

    gray_resized = cv2.resize(gray_roi, resize_to, interpolation=cv2.INTER_LINEAR)

    hog_vec = hog(
        gray_resized,
        orientations=orientations,
        pixels_per_cell=pixels_per_cell,
        cells_per_block=cells_per_block,
        block_norm="L2-Hys",
        visualize=False,
        transform_sqrt=True,
        feature_vector=True,
    )
    return hog_vec.astype(np.float32)


# =========================================================
# LOAD MODEL, PCA, (OPTIONAL) SCALER
# =========================================================

model = None
pca_hog1 = None
scaler_X1 = None  # tidak dipakai langsung

try:
    model = joblib.load(MODEL_PATH)
    print(f"✅ Loaded model pipeline from {MODEL_PATH}")
except Exception as e:
    print(f"❌ Failed to load model: {e}")

try:
    pca_hog1 = joblib.load(PCA_PATH)
    print(f"✅ Loaded PCA for HOG from {PCA_PATH}")
except Exception as e:
    print(f"❌ Failed to load PCA: {e}")

if os.path.exists(SCALER_PATH):
    try:
        scaler_X1 = joblib.load(SCALER_PATH)
        print(f"ℹ️ Loaded scaler_X1 from {SCALER_PATH} (not used directly).")
    except Exception as e:
        print(f"⚠️ Failed to load scaler_X1: {e}")


def extract_features_X1(img_bgr):
    """
    Jalur 1: Haralick (texture) + HOG-PCA (shape).
    Di training: X1 = [Haralick (13) + HOG_PCA (K1_best)] → total 23 fitur.
    """
    if pca_hog1 is None:
        raise RuntimeError("PCA model (pca_hog1) not loaded")

    # Preprocessing 1 (gray) + 2 (color) untuk mask
    gray, _, morph = preprocess_image_gray_pipeline(img_bgr, size=IMG_SIZE)
    _, _, _, mask2, _ = preprocess_image_color_pipeline(img_bgr)

    gray_f = gray.astype(np.float32)
    mask1 = (morph > 0).astype(np.uint8) * 255

    # Haralick pakai mask
    haralick = compute_glcm_haralick_features(gray_f, mask1)  # shape (13,)

    # ROI untuk HOG: ambil dari gray + mask objek (dari pipeline 2)
    roi_gray_full = gray_f
    roi_gray = get_object_roi(roi_gray_full, mask2)
    hog_raw = extract_hog_features(roi_gray)                  # shape (~4356,)

    # 🔹 Projeksi HOG ke ruang PCA yang sama dengan training
    hog_pca = pca_hog1.transform(hog_raw.reshape(1, -1))[0]   # shape (K1_best,)

    # Gabung: [Haralick + HOG_PCA] → X1 (1, 23)
    X1 = np.hstack([haralick, hog_pca]).reshape(1, -1)
    return X1


# =========================================================
# ENDPOINTS
# =========================================================

@app.get("/", response_class=HTMLResponse)
def home():
    return """
    <html>
      <head><title>Veggie Classifier - Jalur 1 SVM</title></head>
      <body style="font-family: sans-serif; text-align:center; padding-top:40px;">
        <h1>Veggie Classifier (Texture + Shape, SVM RBF)</h1>
        <p>Upload foto sayuran (Tomato, Onion White, Pepper Green, Cucumber Ripe, Corn, Pepper Red).</p>
        <form action="/predict" method="post" enctype="multipart/form-data">
          <input type="file" name="file" accept="image/*" required><br><br>
          <button type="submit">Prediksi</button>
        </form>
      </body>
    </html>
    """


@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    if model is None:
        return JSONResponse(
            status_code=500,
            content={"detail": "Model not loaded on server"},
        )

    try:
        img_bytes = await file.read()
        nparr = np.frombuffer(img_bytes, np.uint8)
        img_bgr = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        if img_bgr is None:
            raise ValueError("Cannot decode image")

        # --- fitur sesuai pipeline X1 ---
        X1 = extract_features_X1(img_bgr)

        label_idx: int
        best_conf: float | None = None
        prob_dict = None

        # 1) Kalau pipeline mendukung predict_proba → pakai langsung
        if hasattr(model, "predict_proba"):
            probas = model.predict_proba(X1)[0]          # shape: (n_classes,)
            classes_model = model.classes_               # index kelas di training

            prob_dict = {}
            for idx, p in zip(classes_model, probas):
                lbl = IDX_TO_CLASS.get(int(idx), str(int(idx)))
                prob_dict[lbl] = float(p)

            best_idx = int(np.argmax(probas))
            best_label_idx = int(classes_model[best_idx])

            label_idx = best_label_idx
            best_conf = float(probas[best_idx])

        # 2) Kalau tidak ada predict_proba → pakai decision_function sebagai "skor"
        elif hasattr(model, "decision_function"):
            scores = model.decision_function(X1)         # (1, n_classes) atau (n_classes,)
            scores = np.atleast_2d(scores)[0]            # pastikan 1D

            classes_model = model.classes_
            best_idx = int(np.argmax(scores))
            best_label_idx = int(classes_model[best_idx])
            label_idx = best_label_idx

            # normalisasi kasar 0–1 supaya bisa dipakai sebagai "confidence"
            scores_shift = scores - scores.min()
            denom = scores_shift.sum()
            if denom > 0:
                best_conf = float(scores_shift[best_idx] / denom)
            else:
                best_conf = 1.0 / len(scores_shift)

            # kalau mau, isi juga prob_dict pseudo
            prob_dict = {}
            if denom > 0:
                for idx, s in zip(classes_model, scores_shift):
                    lbl = IDX_TO_CLASS.get(int(idx), str(int(idx)))
                    prob_dict[lbl] = float(s / denom)

        # 3) Fallback paling sederhana
        else:
            pred = model.predict(X1)[0]
            label_idx = int(pred)
            best_conf = None

        label_name = IDX_TO_CLASS.get(label_idx, str(label_idx))

        return {
            "label": label_name,
            "label_index": label_idx,
            "confidence": best_conf,   # sekarang hampir selalu angka 0–1
            "probs": prob_dict,
        }

    except Exception as e:
        return JSONResponse(
            status_code=500,
            content={"detail": f"Error during prediction: {e}"},
        )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=7860)

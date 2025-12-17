# app/schemas/__init__.py

from .auth import *
from .users import *
from .logs import *
from .marketplace import *
from .messages import *
from .ai_agent import *

# 🔽 tambahkan ini
from .kegiatan import (
    KegiatanBase,
    KegiatanCreate,
    KegiatanUpdate,
    KegiatanOut,
)

# jawara_api/app/routers/reports.py
from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import Optional
from datetime import datetime, date
from decimal import Decimal
import os
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont

from ..deps import get_db, get_current_user
from .. import models

router = APIRouter(prefix="/reports", tags=["Reports"])

def format_currency(amount):
    """Format number to Indonesian Rupiah"""
    if amount is None:
        return "Rp 0"
    return f"Rp {amount:,.0f}".replace(",", ".")

def generate_pdf_report(
    report_type: str,
    start_date: date,
    end_date: date,
    income_data: list,
    expense_data: list,
    filename: str
):
    """Generate PDF report"""
    doc = SimpleDocTemplate(filename, pagesize=A4)
    elements = []
    
    # Styles
    styles = getSampleStyleSheet()
    title_style = ParagraphStyle(
        'CustomTitle',
        parent=styles['Heading1'],
        fontSize=16,
        textColor=colors.HexColor('#6A11CB'),
        spaceAfter=30,
        alignment=1  # Center
    )
    
    # Title
    title_map = {
        'pemasukan': 'LAPORAN PEMASUKAN',
        'pengeluaran': 'LAPORAN PENGELUARAN',
        'semua': 'LAPORAN KEUANGAN LENGKAP'
    }
    title = Paragraph(title_map.get(report_type.lower(), 'LAPORAN KEUANGAN'), title_style)
    elements.append(title)
    
    # Period
    period_text = f"Periode: {start_date.strftime('%d %B %Y')} - {end_date.strftime('%d %B %Y')}"
    period = Paragraph(period_text, styles['Normal'])
    elements.append(period)
    elements.append(Spacer(1, 0.3*inch))
    
    # Income Table
    if report_type.lower() in ['pemasukan', 'semua']:
        elements.append(Paragraph('<b>PEMASUKAN</b>', styles['Heading2']))
        elements.append(Spacer(1, 0.2*inch))
        
        income_table_data = [['No', 'Tanggal', 'Nama', 'Jenis', 'Nominal']]
        total_income = Decimal(0)
        
        for idx, item in enumerate(income_data, 1):
            income_table_data.append([
                str(idx),
                item['date'].strftime('%d/%m/%Y') if isinstance(item['date'], date) else item['date'],
                item['name'],
                item['type'] or '-',
                format_currency(item['amount'])
            ])
            total_income += Decimal(str(item['amount']))
        
        income_table_data.append(['', '', '', 'TOTAL', format_currency(float(total_income))])
        
        income_table = Table(income_table_data, colWidths=[0.5*inch, 1*inch, 2*inch, 1.5*inch, 1.5*inch])
        income_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#6A11CB')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 10),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('BACKGROUND', (0, 1), (-1, -2), colors.beige),
            ('BACKGROUND', (0, -1), (-1, -1), colors.HexColor('#B8E6B8')),
            ('FONTNAME', (0, -1), (-1, -1), 'Helvetica-Bold'),
            ('GRID', (0, 0), (-1, -1), 1, colors.black)
        ]))
        elements.append(income_table)
        elements.append(Spacer(1, 0.5*inch))
    
    # Expense Table
    if report_type.lower() in ['pengeluaran', 'semua']:
        elements.append(Paragraph('<b>PENGELUARAN</b>', styles['Heading2']))
        elements.append(Spacer(1, 0.2*inch))
        
        expense_table_data = [['No', 'Tanggal', 'Nama', 'Kategori', 'Nominal']]
        total_expense = Decimal(0)
        
        for idx, item in enumerate(expense_data, 1):
            expense_table_data.append([
                str(idx),
                item['date'].strftime('%d/%m/%Y') if isinstance(item['date'], date) else item['date'],
                item['name'],
                item['category'] or '-',
                format_currency(item['amount'])
            ])
            total_expense += Decimal(str(item['amount']))
        
        expense_table_data.append(['', '', '', 'TOTAL', format_currency(float(total_expense))])
        
        expense_table = Table(expense_table_data, colWidths=[0.5*inch, 1*inch, 2*inch, 1.5*inch, 1.5*inch])
        expense_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#6A11CB')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 10),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('BACKGROUND', (0, 1), (-1, -2), colors.beige),
            ('BACKGROUND', (0, -1), (-1, -1), colors.HexColor('#FFB8B8')),
            ('FONTNAME', (0, -1), (-1, -1), 'Helvetica-Bold'),
            ('GRID', (0, 0), (-1, -1), 1, colors.black)
        ]))
        elements.append(expense_table)
        elements.append(Spacer(1, 0.5*inch))
    
    # Summary for 'semua'
    if report_type.lower() == 'semua':
        total_income = sum(Decimal(str(item['amount'])) for item in income_data)
        total_expense = sum(Decimal(str(item['amount'])) for item in expense_data)
        balance = total_income - total_expense
        
        elements.append(Paragraph('<b>RINGKASAN</b>', styles['Heading2']))
        elements.append(Spacer(1, 0.2*inch))
        
        summary_data = [
            ['Total Pemasukan', format_currency(float(total_income))],
            ['Total Pengeluaran', format_currency(float(total_expense))],
            ['Saldo', format_currency(float(balance))]
        ]
        
        summary_table = Table(summary_data, colWidths=[3*inch, 2*inch])
        summary_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, -1), colors.HexColor('#F0F0F0')),
            ('ALIGN', (0, 0), (0, -1), 'LEFT'),
            ('ALIGN', (1, 0), (1, -1), 'RIGHT'),
            ('FONTNAME', (0, 0), (-1, -1), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 12),
            ('GRID', (0, 0), (-1, -1), 1, colors.black),
            ('BACKGROUND', (0, -1), (-1, -1), colors.HexColor('#6A11CB')),
            ('TEXTCOLOR', (0, -1), (-1, -1), colors.whitesmoke),
        ]))
        elements.append(summary_table)
    
    # Build PDF
    doc.build(elements)

@router.get("/generate")
async def generate_report(
    report_type: str,  # pemasukan, pengeluaran, semua
    start_date: str,   # YYYY-MM-DD
    end_date: str,     # YYYY-MM-DD
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    """Generate financial report PDF"""
    try:
        start = datetime.strptime(start_date, "%Y-%m-%d").date()
        end = datetime.strptime(end_date, "%Y-%m-%d").date()
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid date format. Use YYYY-MM-DD")
    
    # Fetch income data
    income_data = []
    if report_type.lower() in ['pemasukan', 'semua']:
        incomes = (
            db.query(models.IncomeTransaction)
            .filter(models.IncomeTransaction.date.between(start, end))
            .order_by(models.IncomeTransaction.date)
            .all()
        )
        income_data = [
            {
                'date': inc.date,
                'name': inc.name,
                'type': inc.type,
                'amount': float(inc.amount)
            }
            for inc in incomes
        ]
    
    # Fetch expense data
    expense_data = []
    if report_type.lower() in ['pengeluaran', 'semua']:
        expenses = (
            db.query(models.ExpenseTransaction)
            .filter(models.ExpenseTransaction.date.between(start, end))
            .order_by(models.ExpenseTransaction.date)
            .all()
        )
        expense_data = [
            {
                'date': exp.date,
                'name': exp.name,
                'category': exp.category,
                'amount': float(exp.amount)
            }
            for exp in expenses
        ]
    
    # Generate filename
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    filename = f"laporan_{report_type}_{timestamp}.pdf"
    filepath = os.path.join("uploads", filename)
    
    # Ensure uploads directory exists
    os.makedirs("uploads", exist_ok=True)
    
    # Generate PDF
    generate_pdf_report(report_type, start, end, income_data, expense_data, filepath)
    
    # Return file
    return FileResponse(
        path=filepath,
        filename=filename,
        media_type='application/pdf',
        headers={"Content-Disposition": f"attachment; filename={filename}"}
    )
// JavaScript cho phân trang bảng
class TablePagination {
    constructor(tableId, itemsPerPage = 5) {
        this.table = document.getElementById(tableId);
        this.itemsPerPage = itemsPerPage;
        this.currentPage = 1;
        this.totalItems = 0;
        this.totalPages = 0;
        this.filteredRows = [];
        
        if (this.table) {
            this.init();
        }
    }
    
    init() {
        this.tbody = this.table.querySelector('tbody');
        this.rows = Array.from(this.tbody.querySelectorAll('tr'));
        this.totalItems = this.rows.length;
        this.filteredRows = [...this.rows];
        this.calculatePages();
        this.createPaginationContainer();
        this.showPage(1);
    }
    
    calculatePages() {
        this.totalPages = Math.ceil(this.filteredRows.length / this.itemsPerPage);
    }
    
    createPaginationContainer() {
        // Tạo container cho pagination
        const container = document.createElement('div');
        container.className = 'pagination-container';
        container.innerHTML = `
            <div class="pagination-info">
                <span id="${this.table.id}-info">Hiển thị 0 - 0 trong tổng số 0 kết quả</span>
            </div>
            <ul class="pagination" id="${this.table.id}-pagination">
            </ul>
        `;
        
        // Thêm sau bảng
        this.table.parentNode.insertBefore(container, this.table.nextSibling);
        
        this.paginationInfo = document.getElementById(`${this.table.id}-info`);
        this.paginationList = document.getElementById(`${this.table.id}-pagination`);
    }
    
    showPage(pageNumber) {
        if (pageNumber < 1 || pageNumber > this.totalPages) return;
        
        this.currentPage = pageNumber;
        
        // Ẩn tất cả rows
        this.rows.forEach(row => row.style.display = 'none');
        
        // Hiển thị rows cho trang hiện tại
        const start = (pageNumber - 1) * this.itemsPerPage;
        const end = start + this.itemsPerPage;
        
        for (let i = start; i < end && i < this.filteredRows.length; i++) {
            this.filteredRows[i].style.display = '';
        }
        
        this.updatePaginationInfo();
        this.updatePaginationButtons();
    }
    
    updatePaginationInfo() {
        const start = (this.currentPage - 1) * this.itemsPerPage + 1;
        const end = Math.min(this.currentPage * this.itemsPerPage, this.filteredRows.length);
        
        this.paginationInfo.textContent = 
            `Hiển thị ${start} - ${end} trong tổng số ${this.filteredRows.length} kết quả`;
    }
    
    updatePaginationButtons() {
        this.paginationList.innerHTML = '';
        
        if (this.totalPages <= 1) return;
        
        // Previous button
        const prevLi = document.createElement('li');
        prevLi.className = `page-item ${this.currentPage === 1 ? 'disabled' : ''}`;
        prevLi.innerHTML = `<a href="#" class="page-link" data-page="${this.currentPage - 1}">‹</a>`;
        this.paginationList.appendChild(prevLi);
        
        // Page numbers
        let startPage = Math.max(1, this.currentPage - 2);
        let endPage = Math.min(this.totalPages, this.currentPage + 2);
        
        if (startPage > 1) {
            const firstLi = document.createElement('li');
            firstLi.className = 'page-item';
            firstLi.innerHTML = `<a href="#" class="page-link" data-page="1">1</a>`;
            this.paginationList.appendChild(firstLi);
            
            if (startPage > 2) {
                const ellipsisLi = document.createElement('li');
                ellipsisLi.className = 'page-item disabled';
                ellipsisLi.innerHTML = `<span class="page-link">...</span>`;
                this.paginationList.appendChild(ellipsisLi);
            }
        }
        
        for (let i = startPage; i <= endPage; i++) {
            const li = document.createElement('li');
            li.className = `page-item ${i === this.currentPage ? 'active' : ''}`;
            li.innerHTML = `<a href="#" class="page-link" data-page="${i}">${i}</a>`;
            this.paginationList.appendChild(li);
        }
        
        if (endPage < this.totalPages) {
            if (endPage < this.totalPages - 1) {
                const ellipsisLi = document.createElement('li');
                ellipsisLi.className = 'page-item disabled';
                ellipsisLi.innerHTML = `<span class="page-link">...</span>`;
                this.paginationList.appendChild(ellipsisLi);
            }
            
            const lastLi = document.createElement('li');
            lastLi.className = 'page-item';
            lastLi.innerHTML = `<a href="#" class="page-link" data-page="${this.totalPages}">${this.totalPages}</a>`;
            this.paginationList.appendChild(lastLi);
        }
        
        // Next button
        const nextLi = document.createElement('li');
        nextLi.className = `page-item ${this.currentPage === this.totalPages ? 'disabled' : ''}`;
        nextLi.innerHTML = `<a href="#" class="page-link" data-page="${this.currentPage + 1}">›</a>`;
        this.paginationList.appendChild(nextLi);
        
        // Add click events
        this.paginationList.addEventListener('click', (e) => {
            e.preventDefault();
            if (e.target.classList.contains('page-link') && !e.target.parentNode.classList.contains('disabled')) {
                const page = parseInt(e.target.getAttribute('data-page'));
                if (page) {
                    this.showPage(page);
                }
            }
        });
    }
    
    filter(searchTerm) {
        if (!searchTerm) {
            this.filteredRows = [...this.rows];
        } else {
            this.filteredRows = this.rows.filter(row => {
                const text = row.textContent.toLowerCase();
                return text.includes(searchTerm.toLowerCase());
            });
        }
        
        this.calculatePages();
        this.showPage(1);
    }
    
    refresh() {
        this.rows = Array.from(this.tbody.querySelectorAll('tr'));
        this.totalItems = this.rows.length;
        this.filteredRows = [...this.rows];
        this.calculatePages();
        this.showPage(1);
    }
}

// Excel Export functionality
class ExcelExporter {
    constructor() {
        this.workbook = null;
    }
    
    exportRevenueData() {
        const data = this.collectAllData();
        this.downloadExcel(data, 'BaoCaoDoanhThu_' + this.getCurrentDate());
    }
    
    collectAllData() {
        const data = {
            summary: this.getSummaryData(),
            monthlyRevenue: this.getTableData('productTable', 'Doanh thu theo tháng'),
            productRevenue: this.getTableData('productTable', 'Doanh thu theo sản phẩm'),
            customerRevenue: this.getTableData('customerTable', 'Top khách hàng'),
            damagedFlowers: this.getTableData('damagedTable', 'Hoa thiệt hại'),
            importCosts: this.getTableData('importTable', 'Chi phí nhập hàng')
        };
        
        return data;
    }
    
    getSummaryData() {
        const summaryCards = document.querySelectorAll('.summary-card');
        const summary = [];
        
        summaryCards.forEach(card => {
            const title = card.querySelector('p').textContent;
            const value = card.querySelector('h3').textContent;
            summary.push([title, value]);
        });
        
        return summary;
    }
    
    getTableData(tableId, sheetName) {
        const table = document.getElementById(tableId);
        if (!table) return { name: sheetName, data: [] };
        
        const headers = [];
        const rows = [];
        
        // Get headers
        const headerCells = table.querySelectorAll('thead th');
        headerCells.forEach(cell => headers.push(cell.textContent.trim()));
        
        // Get all rows (not just visible ones)
        const bodyRows = table.querySelectorAll('tbody tr');
        bodyRows.forEach(row => {
            const rowData = [];
            const cells = row.querySelectorAll('td');
            cells.forEach(cell => rowData.push(cell.textContent.trim()));
            if (rowData.length > 0) rows.push(rowData);
        });
        
        return {
            name: sheetName,
            data: [headers, ...rows]
        };
    }
    
    downloadExcel(data, filename) {
        // Create workbook
        let csvContent = "data:text/csv;charset=utf-8,\uFEFF";
        
        // Add summary sheet
        csvContent += "=== TỔNG QUAN ===\n";
        data.summary.forEach(row => {
            csvContent += row.join(",") + "\n";
        });
        csvContent += "\n";
        
        // Add each data sheet
        Object.keys(data).forEach(key => {
            if (key !== 'summary' && data[key].data.length > 0) {
                csvContent += `=== ${data[key].name.toUpperCase()} ===\n`;
                data[key].data.forEach(row => {
                    csvContent += row.join(",") + "\n";
                });
                csvContent += "\n";
            }
        });
        
        // Download
        const encodedUri = encodeURI(csvContent);
        const link = document.createElement("a");
        link.setAttribute("href", encodedUri);
        link.setAttribute("download", filename + ".csv");
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        
        this.showSuccessMessage("Xuất file Excel thành công!");
    }
    
    getCurrentDate() {
        const now = new Date();
        return now.getFullYear() + 
               String(now.getMonth() + 1).padStart(2, '0') + 
               String(now.getDate()).padStart(2, '0');
    }
    
    showSuccessMessage(message) {
        // Create toast notification
        const toast = document.createElement('div');
        toast.className = 'toast-notification success';
        toast.innerHTML = `
            <i class="fas fa-check-circle me-2"></i>
            ${message}
        `;
        
        // Add styles
        toast.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: #28a745;
            color: white;
            padding: 15px 20px;
            border-radius: 5px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            z-index: 10000;
            animation: slideIn 0.3s ease-out;
        `;
        
        document.body.appendChild(toast);
        
        // Remove after 3 seconds
        setTimeout(() => {
            toast.style.animation = 'slideOut 0.3s ease-in';
            setTimeout(() => document.body.removeChild(toast), 300);
        }, 3000);
    }
}

// Initialize pagination for all tables
document.addEventListener('DOMContentLoaded', function() {
    // Initialize pagination for each table
    const tables = ['productTable', 'customerTable', 'damagedTable', 'importTable'];
    const paginations = {};
    
    tables.forEach(tableId => {
        const table = document.getElementById(tableId);
        if (table) {
            paginations[tableId] = new TablePagination(tableId, 5);
        }
    });
    
    // Store paginations globally
    window.tablePaginations = paginations;
    
    // Initialize Excel exporter
    window.excelExporter = new ExcelExporter();
});

// Add CSS for toast notifications
const toastStyles = document.createElement('style');
toastStyles.textContent = `
    @keyframes slideIn {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    
    @keyframes slideOut {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }
`;
document.head.appendChild(toastStyles);

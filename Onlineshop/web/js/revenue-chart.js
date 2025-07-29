// JavaScript cho trang báo cáo doanh thu
class RevenueChartManager {
    constructor() {
        this.charts = {};
        this.colors = {
            primary: ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e', '#e74a3b', '#858796'],
            gradients: {
                blue: ['#4e73df', '#224abe'],
                green: ['#1cc88a', '#13855c'],
                cyan: ['#36b9cc', '#258391'],
                yellow: ['#f6c23e', '#dda20a'],
                red: ['#e74a3b', '#c0392b'],
                gray: ['#858796', '#5a5c69']
            }
        };
        this.init();
    }

    init() {
        // Khởi tạo tất cả biểu đồ
        this.initMonthlyRevenueChart();
        this.initStatusChart();
        this.initProductRevenueChart();
        this.initCustomerRevenueChart();
        this.initDamagedFlowerChart();
        this.initImportRevenueChart();
        this.initComparisonChart();
        
        // Thêm event listeners
        this.addEventListeners();
    }

    // Tạo gradient cho biểu đồ
    createGradient(ctx, colorStart, colorEnd) {
        const gradient = ctx.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, colorStart);
        gradient.addColorStop(1, colorEnd);
        return gradient;
    }

    // Biểu đồ doanh thu theo tháng
    initMonthlyRevenueChart() {
        const ctx = document.getElementById('monthlyChart');
        if (!ctx || typeof revenueData === 'undefined') return;

        this.charts.monthly = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: revenueLabels,
                datasets: [{
                    label: 'Doanh thu (VND)',
                    data: revenueData,
                    backgroundColor: '#4e73df',
                    borderColor: '#4e73df',
                    borderWidth: 2,
                    borderRadius: 8,
                    borderSkipped: false,
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                        labels: {
                            usePointStyle: true,
                            padding: 20
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0,0,0,0.8)',
                        titleColor: 'white',
                        bodyColor: 'white',
                        borderColor: '#4e73df',
                        borderWidth: 1,
                        callbacks: {
                            label: function(context) {
                                return new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND'
                                }).format(context.parsed.y);
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN').format(value) + ' đ';
                            }
                        },
                        grid: {
                            color: 'rgba(0,0,0,0.1)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                },
                animation: {
                    duration: 2000,
                    easing: 'easeInOutQuart'
                }
            }
        });
    }

    // Biểu đồ trạng thái đơn hàng (tròn)
    initStatusChart() {
        const ctx = document.getElementById('statusChart');
        if (!ctx || typeof statusData === 'undefined') return;

        this.charts.status = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: statusLabels,
                datasets: [{
                    data: statusData,
                    backgroundColor: this.colors.primary,
                    borderWidth: 3,
                    borderColor: '#fff',
                    hoverBorderWidth: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 20,
                            usePointStyle: true
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0,0,0,0.8)',
                        callbacks: {
                            label: function(context) {
                                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                const percentage = ((context.parsed / total) * 100).toFixed(1);
                                return `${context.label}: ${context.parsed} đơn (${percentage}%)`;
                            }
                        }
                    }
                },
                animation: {
                    animateRotate: true,
                    duration: 2000
                }
            }
        });
    }

    // Biểu đồ doanh thu theo sản phẩm
    initProductRevenueChart() {
        const ctx = document.getElementById('productChart');
        if (!ctx || typeof productData === 'undefined') return;

        this.charts.product = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: productLabels,
                datasets: [{
                    label: 'Doanh thu (VND)',
                    data: productData,
                    backgroundColor: '#1cc88a',
                    borderColor: '#1cc88a',
                    borderWidth: 2,
                    yAxisID: 'y'
                }, {
                    label: 'Số lượng bán',
                    data: productQuantities,
                    backgroundColor: '#36b9cc',
                    borderColor: '#36b9cc',
                    borderWidth: 2,
                    yAxisID: 'y1'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: {
                    mode: 'index',
                    intersect: false,
                },
                plugins: {
                    legend: {
                        position: 'top'
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0,0,0,0.8)',
                        callbacks: {
                            label: function(context) {
                                if (context.datasetIndex === 0) {
                                    return `Doanh thu: ${new Intl.NumberFormat('vi-VN').format(context.parsed.y)} đ`;
                                } else {
                                    return `Số lượng: ${context.parsed.y} sản phẩm`;
                                }
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        grid: {
                            display: false
                        }
                    },
                    y: {
                        type: 'linear',
                        display: true,
                        position: 'left',
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN').format(value) + ' đ';
                            }
                        }
                    },
                    y1: {
                        type: 'linear',
                        display: true,
                        position: 'right',
                        beginAtZero: true,
                        grid: {
                            drawOnChartArea: false,
                        },
                        ticks: {
                            callback: function(value) {
                                return value + ' sp';
                            }
                        }
                    }
                }
            }
        });
    }

    // Biểu đồ doanh thu theo khách hàng
    initCustomerRevenueChart() {
        const ctx = document.getElementById('customerChart');
        if (!ctx || typeof customerData === 'undefined') return;

        this.charts.customer = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: customerLabels,
                datasets: [{
                    label: 'Tổng chi tiêu (VND)',
                    data: customerData,
                    backgroundColor: '#f6c23e',
                    borderColor: '#f6c23e',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                indexAxis: 'y',
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0,0,0,0.8)',
                        callbacks: {
                            label: function(context) {
                                return new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND'
                                }).format(context.parsed.x);
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN').format(value) + ' đ';
                            }
                        }
                    },
                    y: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    }

    // Biểu đồ hoa thiệt hại
    initDamagedFlowerChart() {
        const ctx = document.getElementById('damagedChart');
        if (!ctx || typeof damagedMonthData === 'undefined') return;

        this.charts.damaged = new Chart(ctx, {
            type: 'line',
            data: {
                labels: damagedMonthLabels,
                datasets: [{
                    label: 'Thiệt hại (VND)',
                    data: damagedMonthData,
                    backgroundColor: 'rgba(231, 74, 59, 0.1)',
                    borderColor: '#e74a3b',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#e74a3b',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2,
                    pointRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(231, 74, 59, 0.8)',
                        callbacks: {
                            label: function(context) {
                                return new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND'
                                }).format(context.parsed.y);
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN').format(value) + ' đ';
                            }
                        }
                    }
                }
            }
        });
    }

    // Biểu đồ doanh thu nhập hàng
    initImportRevenueChart() {
        const ctx = document.getElementById('importChart');
        if (!ctx || typeof importMonthData === 'undefined') return;

        this.charts.import = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: importMonthLabels,
                datasets: [{
                    label: 'Chi phí nhập hàng (VND)',
                    data: importMonthData,
                    backgroundColor: '#36b9cc',
                    borderColor: '#36b9cc',
                    borderWidth: 2,
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(54, 185, 204, 0.8)',
                        callbacks: {
                            label: function(context) {
                                return new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND'
                                }).format(context.parsed.y);
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN').format(value) + ' đ';
                            }
                        }
                    }
                }
            }
        });
    }

    // Biểu đồ so sánh doanh thu - nhập hàng - thiệt hại
    initComparisonChart() {
        const ctx = document.getElementById('comparisonChart');
        if (!ctx) return;

        // Tạo dữ liệu cho 12 tháng
        const months = [];
        const revenueDataForComparison = new Array(12).fill(0);
        const importDataForComparison = new Array(12).fill(0);
        const damageDataForComparison = new Array(12).fill(0);

        for (let i = 1; i <= 12; i++) {
            months.push(`T${i}`);
        }

        // Điền dữ liệu doanh thu
        if (typeof revenueData !== 'undefined' && typeof revenueLabels !== 'undefined') {
            for (let i = 0; i < revenueLabels.length; i++) {
                const monthMatch = revenueLabels[i].match(/\d+/);
                if (monthMatch) {
                    const monthIndex = parseInt(monthMatch[0]) - 1;
                    if (monthIndex >= 0 && monthIndex < 12) {
                        revenueDataForComparison[monthIndex] = revenueData[i];
                    }
                }
            }
        }

        // Điền dữ liệu nhập hàng
        if (typeof importMonthData !== 'undefined' && typeof importMonthLabels !== 'undefined') {
            for (let i = 0; i < importMonthLabels.length; i++) {
                const monthMatch = importMonthLabels[i].match(/\d+/);
                if (monthMatch) {
                    const monthIndex = parseInt(monthMatch[0]) - 1;
                    if (monthIndex >= 0 && monthIndex < 12) {
                        importDataForComparison[monthIndex] = importMonthData[i];
                    }
                }
            }
        }

        // Điền dữ liệu thiệt hại
        if (typeof damagedMonthData !== 'undefined' && typeof damagedMonthLabels !== 'undefined') {
            for (let i = 0; i < damagedMonthLabels.length; i++) {
                const monthMatch = damagedMonthLabels[i].match(/\d+/);
                if (monthMatch) {
                    const monthIndex = parseInt(monthMatch[0]) - 1;
                    if (monthIndex >= 0 && monthIndex < 12) {
                        damageDataForComparison[monthIndex] = damagedMonthData[i];
                    }
                }
            }
        }

        this.charts.comparison = new Chart(ctx, {
            type: 'line',
            data: {
                labels: months,
                datasets: [{
                    label: 'Doanh thu',
                    data: revenueDataForComparison,
                    borderColor: '#1cc88a',
                    backgroundColor: 'rgba(28, 200, 138, 0.1)',
                    borderWidth: 3,
                    fill: false,
                    tension: 0.4
                }, {
                    label: 'Chi phí nhập hàng',
                    data: importDataForComparison,
                    borderColor: '#36b9cc',
                    backgroundColor: 'rgba(54, 185, 204, 0.1)',
                    borderWidth: 3,
                    fill: false,
                    tension: 0.4
                }, {
                    label: 'Thiệt hại',
                    data: damageDataForComparison,
                    borderColor: '#e74a3b',
                    backgroundColor: 'rgba(231, 74, 59, 0.1)',
                    borderWidth: 3,
                    fill: false,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top'
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0,0,0,0.8)',
                        callbacks: {
                            label: function(context) {
                                return `${context.dataset.label}: ${new Intl.NumberFormat('vi-VN').format(context.parsed.y)} đ`;
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN').format(value) + ' đ';
                            }
                        }
                    }
                },
                interaction: {
                    mode: 'index',
                    intersect: false
                }
            }
        });
    }

    // Thêm event listeners
    addEventListeners() {
        // Auto submit form khi thay đổi dropdown
        const monthSelect = document.querySelector('select[name="selectedMonth"]');
        if (monthSelect) {
            monthSelect.addEventListener('change', function() {
                this.form.submit();
            });
        }

        // Smooth scrolling cho navigation
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Thêm animation cho cards khi scroll
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('fade-in');
                }
            });
        }, observerOptions);

        document.querySelectorAll('.chart-card').forEach(card => {
            observer.observe(card);
        });
    }

    // Cập nhật biểu đồ
    updateChart(chartName, newData) {
        if (this.charts[chartName]) {
            this.charts[chartName].data = newData;
            this.charts[chartName].update('active');
        }
    }

    // Xuất biểu đồ thành hình ảnh
    exportChart(chartName) {
        if (this.charts[chartName]) {
            const link = document.createElement('a');
            link.download = `${chartName}-chart.png`;
            link.href = this.charts[chartName].toBase64Image();
            link.click();
        }
    }

    // Resize tất cả biểu đồ
    resizeCharts() {
        Object.values(this.charts).forEach(chart => {
            chart.resize();
        });
    }
}

// Khởi tạo khi DOM loaded
document.addEventListener('DOMContentLoaded', function() {
    window.revenueChartManager = new RevenueChartManager();
    
    // Resize charts khi thay đổi kích thước window
    window.addEventListener('resize', function() {
        window.revenueChartManager.resizeCharts();
    });
});

// Utility functions
function formatCurrency(value) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(value);
}

function formatNumber(value) {
    return new Intl.NumberFormat('vi-VN').format(value);
}

// Print function
function printReport() {
    window.print();
}

// Export to Excel (cải tiến)
function exportToExcel() {
    if (window.excelExporter) {
        window.excelExporter.exportRevenueData();
    } else {
        // Fallback method using CSV
        exportToCSV();
    }
}

function exportToCSV() {
    const csvData = [];
    
    // Header
    csvData.push(['BÁO CÁO DOANH THU CHI TIẾT']);
    csvData.push(['Ngày xuất:', new Date().toLocaleDateString('vi-VN')]);
    csvData.push([]);
    
    // Summary data
    csvData.push(['=== TỔNG QUAN ===']);
    const summaryCards = document.querySelectorAll('.summary-card');
    summaryCards.forEach(card => {
        const title = card.querySelector('p').textContent;
        const value = card.querySelector('h3').textContent;
        csvData.push([title, value]);
    });
    csvData.push([]);
    
    // Revenue by month
    if (typeof revenueData !== 'undefined') {
        csvData.push(['=== DOANH THU THEO THÁNG ===']);
        csvData.push(['Tháng', 'Doanh thu (VND)']);
        for (let i = 0; i < revenueLabels.length; i++) {
            csvData.push([revenueLabels[i], revenueData[i]]);
        }
        csvData.push([]);
    }
    
    // Export tables
    exportTableToCSV('productTable', 'DOANH THU THEO SẢN PHẨM', csvData);
    exportTableToCSV('customerTable', 'TOP KHÁCH HÀNG', csvData);
    exportTableToCSV('damagedTable', 'HOA THIỆT HẠI', csvData);
    exportTableToCSV('importTable', 'CHI PHÍ NHẬP HÀNG', csvData);
    
    // Download CSV
    downloadCSV(csvData, 'BaoCaoDoanhThu_' + getCurrentDateString());
}

function exportTableToCSV(tableId, title, csvData) {
    const table = document.getElementById(tableId);
    if (!table) return;
    
    csvData.push([`=== ${title} ===`]);
    
    // Headers
    const headers = [];
    table.querySelectorAll('thead th').forEach(th => {
        headers.push(th.textContent.trim());
    });
    csvData.push(headers);
    
    // Rows
    table.querySelectorAll('tbody tr').forEach(tr => {
        const row = [];
        tr.querySelectorAll('td').forEach(td => {
            // Clean up text content
            let text = td.textContent.trim();
            text = text.replace(/\s+/g, ' '); // Remove extra whitespace
            row.push(text);
        });
        if (row.length > 0) csvData.push(row);
    });
    
    csvData.push([]);
}

function downloadCSV(data, filename) {
    const csvContent = '\uFEFF' + data.map(row => 
        row.map(cell => `"${cell}"`).join(',')
    ).join('\n');
    
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = filename + '.csv';
    link.click();
    
    showToast('Xuất file Excel thành công!', 'success');
}

function getCurrentDateString() {
    const now = new Date();
    return now.getFullYear() + 
           String(now.getMonth() + 1).padStart(2, '0') + 
           String(now.getDate()).padStart(2, '0');
}

function showToast(message, type = 'info') {
    const toast = document.createElement('div');
    toast.className = `toast-notification ${type}`;
    toast.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' : 'info-circle'} me-2"></i>
        ${message}
    `;
    
    toast.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${type === 'success' ? '#28a745' : '#17a2b8'};
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        z-index: 10000;
        animation: slideInRight 0.3s ease-out;
        max-width: 300px;
    `;
    
    document.body.appendChild(toast);
    
    setTimeout(() => {
        toast.style.animation = 'slideOutRight 0.3s ease-in';
        setTimeout(() => {
            if (document.body.contains(toast)) {
                document.body.removeChild(toast);
            }
        }, 300);
    }, 3000);
}

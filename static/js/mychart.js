// 条形图
function ranking_line(canvas) {
    canvas.height = 60;
    var ctx = canvas.getContext('2d');
    // 配置图表数据
    var myChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['10', '20', '30', '40', '50', '60'], // X轴标签
            datasets: [
                {
                    label: 'Sakana',
                    data: [10, 20, 30, 50, 100, 400],
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderColor: 'rgb(75, 192, 192)',
                    borderWidth: 1
                },
                {
                    label: 'Chinanako',
                    data: [20, 30, 40, 60, 80, 120],
                    backgroundColor: 'rgba(255, 159, 64, 0.2)',
                    borderColor: 'rgb(255, 159, 64)',
                    borderWidth: 1
                },
                {
                    label: 'mygo',
                    data: [30, 40, 50, 70, 90, 130],
                    backgroundColor: 'rgba(255, 99, 132, 0.2)',
                    borderColor: 'rgb(255, 99, 132)',
                    borderWidth: 1
                },
                {
                    label: 'kirakira',
                    data: [40, 50, 60, 100, 150, 200], // 示例数据
                    backgroundColor: 'rgba(248, 215, 26, 0.2)',
                    borderColor: 'rgb(248, 215, 26)',
                    borderWidth: 1
                },
                {
                    label: 'mujica',
                    data: [100, 110, 120, 130, 140, 150],
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgb(54, 162, 235)',
                    borderWidth: 1
                }
            ]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });


}

// 环形中心
function ranking_doughnut(canvas) {
    canvas.height = 10;
    var ctx = canvas.getContext('2d');
    // 配置图表数据
    var myChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            datasets: [{
                data: [10, 20],
                backgroundColor: ['green', 'red'],
                BorderColor: 'rgba(0, 0, 0, 0)',
        }],
    
        // These labels appear in the legend and in the tooltips when hovering different arcs
        labels: [
            '解决',
            '未解决',
        ]}
    });
}

// 极面积图
function ranking_polararea(canvas) {
    canvas.height = 10;
    var ctx = canvas.getContext('2d');
    // 配置图表数据
    var myChart = new Chart(ctx, {
        type: 'polarArea',
        data: {
            datasets: [{
                data: [10, 20, 15, 2, 7],
                backgroundColor: [
                    'rgb(255, 0, 0)',
                    'rgb(0, 255, 0)',
                    'rgb(0, 0, 255)',
                    'rgb(255, 255, 0)',
                    'rgb(0, 255, 255)',
                ],
        }],
    
        // These labels appear in the legend and in the tooltips when hovering different arcs
        labels: [
            'PWN',
            'Crypto',
            'web',
            'MUSC',
            'Reverse'
        ]}
    });
}

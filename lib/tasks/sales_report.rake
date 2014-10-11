namespace :notice do
  task sales_report: :environment do
    @daily_order_report = DailyOrderReport.new(30.days.ago.to_date, Date.current)

    amount_chart_options = <<-OPTIONS
    {
        chart: {
            type: 'area',
            width: 1440
        },
        title: {
          text: '前30天 B2C 订单销售额 #{@daily_order_report.total_amount} 元'
        },
        subtitle: {
            text: ''
        },
        xAxis: {
          categories: [#{@daily_order_report.short_dates.join(',')}],
            tickmarkPlacement: 'on',
            title: {
                enabled: false
            }
        },
        yAxis: {
            title: {
                text: '金额'
            },
            labels: {
                formatter: function() {
                    return this.value;
                }
            }
        },
        tooltip: {
            shared: true,
            valueSuffix: ' 元'
        },
        plotOptions: {
            area: {
                stacking: 'normal',
                lineColor: '#666666',
                lineWidth: 1,
                marker: {
                    lineWidth: 1,
                    lineColor: '#666666'
                }
            }
        },
        series: [{
            name: '官网',
            data: [#{@daily_order_report.order_amounts_by_date('normal').join(',')}]
        }, {
            name: '淘宝',
            data: [#{@daily_order_report.order_amounts_by_date('taobao').join(',')}]
        }, {
            name: '天猫',
            data: [#{@daily_order_report.order_amounts_by_date('tmall').join(',')}]
        }, {
            name: '京东',
            data: [#{@daily_order_report.order_amounts_by_date('jd').join(',')}]
        }, {
            name: '一号店',
            data: [#{@daily_order_report.order_amounts_by_date('yhd').join(',')}]
        }]
    }
    OPTIONS
    @amount_chart_image_url = Highcharts::Converter.run(amount_chart_options)

    count_chart_options = <<-OPTIONS
    {
        chart: {
            type: 'area',
            width: 1440
        },
        title: {
          text: '前30天 B2C 订单数量 #{@daily_order_report.total_count} 单'
        },
        subtitle: {
            text: ''
        },
        xAxis: {
          categories: [#{@daily_order_report.short_dates.join(',')}],
            tickmarkPlacement: 'on',
            title: {
                enabled: false
            }
        },
        yAxis: {
            title: {
                text: '单'
            },
            labels: {
                formatter: function() {
                    return this.value;
                }
            }
        },
        tooltip: {
            shared: true,
            valueSuffix: ' 单'
        },
        plotOptions: {
            area: {
                stacking: 'normal',
                lineColor: '#666666',
                lineWidth: 1,
                marker: {
                    lineWidth: 1,
                    lineColor: '#666666'
                }
            }
        },
        series: [{
            name: '官网',
            data: [#{@daily_order_report.order_counts_by_date('normal').join(',')}]
        }, {
            name: '淘宝',
            data: [#{@daily_order_report.order_counts_by_date('taobao').join(',')}]
        }, {
            name: '天猫',
            data: [#{@daily_order_report.order_counts_by_date('tmall').join(',')}]
        }, {
            name: '京东',
            data: [#{@daily_order_report.order_counts_by_date('jd').join(',')}]
        }, {
            name: '一号店',
            data: [#{@daily_order_report.order_counts_by_date('yhd').join(',')}]
        }]
    }
    OPTIONS
    @count_chart_image_url = Highcharts::Converter.run(count_chart_options)

    Notify.delay.sales_report(@daily_order_report.average_order_amount,
                              @amount_chart_image_url,
                              @count_chart_image_url,
                              'ben@tzgpartners.com',
                              'tony@tzgpartners.com',
                              'john@hua.li',
                              'JohnLoong@gmail.com',
                              'ryan@hua.li',
                              'lin@hua.li',
                              'tyler@hua.li',
                              'ella@hua.li',
                              'jeffery@hua.li')
  end
end

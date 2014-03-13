class OrderExcelDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all

  FRESH_FLOWERS = [22, 23, 28, 102, 125, 44, 135, 117, 132, 114, 87, 145, 154, 91, 48, 53, 131, 29, 52, 25, 75, 148, 51, 92]
  COLUMNS = ["下单时间",
             "下单星期",
             "订单号",
             "订单类型",
             "订单状态",
             "到货日期",
             "到货星期",
             "发货日期",
             "发货星期",
             "快递方式",
             "快递单号",
             "花品名称",
             "鲜花/永生花",
             "送花人姓名",
             "送花人邮箱",
             "联系方式",
             "收花人姓名",
             "联系方式",
             "性别",
             "买花用途",
             "收赠关系",
             "来源",
             "省份",
             "城市",
             "地区",
             "详细地址",
             "支付方式",
             "交易编号",
             "送达情况",
             "满意度",
             "问题类别",
             "处理意见",
             "问题详情"]

  COLUMN_TYPES = [nil,# 下单时间
             :string, # 下单星期
             :string, # 订单号
             :string, # 订单类型
             :string, # 订单状态
             nil, # 到货日期
             :string, # 到货星期
             nil, # 发货日期
             :string, # 发货星期
             :string, # 快递方式
             :string, # 快递单号
             :string, # 花品名称
             :string, # 鲜花/永生花
             :string, # 送花人姓名
             :string, # 送花人邮箱
             :string, # 联系方式
             :string, # 收花人姓名
             :string, # 联系方式
             :string, # 性别
             :string, # 买花用途
             :string, # 收赠关系
             :string, # 来源
             :string, # 省份
             :string, # 城市
             :string, # 地区
             :string, # 详细地址
             :string, # 支付方式
             :string, # 交易编号
             :string, # 送达情况
             :string, # 满意度
             :string, # 问题类别
             :string, # 处理意见
             :string # 问题详情
  ]

  def self.flower_type(line_item)
    FRESH_FLOWERS.include?(line_item.product_id) ? "鲜花" : "永生花"
  end

  def created_on
    created_at.to_date
  end

  def create_week
    created_at.strftime("%A")
  end

  def state_text
    I18n.t(state, scope: 'models.order.state')
  end

  def expected_date_week
    expected_date ? expected_date.strftime("%A") : ''
  end

  def delivery_date_week
    delivery_date ? delivery_date.strftime("%A") : ''
  end

  # All line item row in excel
  def items
    @items ||= line_items.to_a
  end

  # First line item row in excel
  def first_item
    items.first
  end

  def left_items
    items[1..-1]
  end

  # First line item flower type row in excel
  def first_flower_type
    self.class.flower_type(first_item)
  end

  def receiver_name
    address.fullname
  end

  def receiver_phone
    address.phone
  end

  def receiver_province
    address.province_name
  end

  def receiver_city
    address.city_name
  end

  def receiver_area
    address.area_name
  end

  def receiver_address
    address.address
  end

  def shipment_tracking_num
    shipment.try(:tracking_num)
  end

  def success_transaction
    @success_transaction ||= transactions.find { |t| t.state = "completed" }
  end

  def transaction_merchant_name
    success_transaction ? success_transaction.merchant_name : ""
  end

  def transaction_merchant_trade_no
    success_transaction ? success_transaction.merchant_trade_no : ""
  end

  def first_row
    [created_on,
     create_week,
     identifier,
     kind_text,
     state_text,
     expected_date,
     expected_date_week,
     delivery_date,
     delivery_date_week,
     ship_method,
     shipment_tracking_num,
     first_item.name,
     first_flower_type,
     sender_name,
     sender_email,
     sender_phone,
     receiver_name,
     receiver_phone,
     "",# 性别
     "", # 买花用途
     "", #收赠关系
     object.source,
     receiver_province,
     receiver_city,
     receiver_area,
     receiver_address,
     transaction_merchant_name,
     transaction_merchant_trade_no,
     "", # 送达情况
     "", # 满意度
     "", # 问题类别
     "", # 处理意见
     "" #问题详情
    ]
  end

  def left_rows
    left_items.map do |item|
      ["",
       "",
       "",
       "",
       "",
       "",
       "",
       "",
       "",
       "",
       "",
       item.name,
       self.class.flower_type(item),
       "",
       "",
       "",
       "",
       "",
       "",# 性别
       "", # 买花用途
       "", #收赠关系
       "",
       "",
       "",
       "",
       "",
       "",
       "",
       "", # 送达情况
       "", # 满意度
       "", # 问题类别
       "", # 处理意见
       "" #问题详情
      ]
    end
  end

  def all_rows
    left_rows << first_row
  end
end

require 'axlsx'

if Mime::Type.lookup_by_extension(:xlsx).nil?
  # The mime type to be used in respond_to |format| style web-services in rails
  Mime::Type.register "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :xlsx
end

class XlsxBuilder
  # The columns this builder will be serializing
  attr_reader :columns

  # The collection we are serializing.
  # @note This is only available after serialize has been called,
  # and is reset on each subsequent call.
  attr_reader :row_data

  # @param [Array] columns the columns of the excel to build
  # @param [Array] row_data the row data of the excel to build
  # @param [Hash] options the options for this builder
  # @option [Hash] :header_style - a hash of style properties to apply
  #   to the header row. Any properties specified will be merged with the default
  #   header styles. @see Axlsx::Styles#add_style
  # @option [Array] :i18n_scope - the I18n scope to use when looking
  #   up localized column headers.
  def initialize(columns, row_data, options = {})
    @columns = columns
    @row_data = row_data
    parse_options options
  end

  # The default header style
  # @return [Hash]
  def header_style
    @header_style ||= { :bg_color => '', :fg_color => '00', :sz => 12, :alignment => { :horizontal => :center } }
  end

  # The scope to use when looking up column names to generate the report header
  def i18n_scope
    @i18n_scope ||= nil
  end

  # This is the I18n scope that will be used when looking up your
  # colum names in the current I18n locale.
  # If you set it to [:active_admin, :resources, :posts] the
  # serializer will render the value at active_admin.resources.posts.title in the
  # current translations
  # @note If you do not set this, the column name will be titleized.
  def i18n_scope=(scope)
    @i18n_scope = scope
  end

  def serialize
    build
    to_stream
  end

  private

  def build
    header_row
    row_data.each { |row| sheet.add_row row }
  end

  def parse_options(options)
    options.each do |key, value|
      self.send("#{key}=", value) if self.respond_to?("#{key}=") && value != nil
    end
  end

  def sheet
    @sheet ||= package.workbook.add_worksheet
  end

  def package
    @package ||= ::Axlsx::Package.new(:use_shared_strings => true)
  end

  def to_stream
    stream = package.to_stream.read
    clean_up
    stream
  end

  def clean_up
    @package = @sheet = nil
  end

  # tranform column names into array of localized strings
  # @return [Array]
  def header_row
    sheet.add_row columns.map { |column| localized_column(column, i18n_scope) }, :style => header_style_id
  end

  def header_style_id
    package.workbook.styles.add_style header_style
  end

  def localized_column(column, i18n_scope = nil)
    return column.to_s.titleize unless i18n_scope
    I18n.t column, scope: i18n_scope
  end
end

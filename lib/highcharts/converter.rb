require 'tempfile'

module Highcharts
  class Converter
    def self.options
      @@options ||= {}
    end

    def self.run(chart_options)
      chart_options_file = Tempfile.new('chart_options')

      image_filename = "#{SecureRandom.hex(32)}.svg"
      sales_report_dir = File.join(::Rails.root, 'public', 'system', 'sales_report') and FileUtils.mkdir_p(sales_report_dir)
      outfile_path = File.join(sales_report_dir, image_filename) and FileUtils.touch(outfile_path)
      url_path = File.join('/', 'system', 'sales_report', image_filename)

      begin
        chart_options_file.write(chart_options)
        chart_options_file.flush
        system "#{phantomjs_path} #{File.expand_path('../highcharts-convert.js', __FILE__)} -infile #{chart_options_file.path} -outfile #{outfile_path} -type svg -constr Chart -width 1440"
      ensure
        chart_options_file.close
        chart_options_file.unlink   # deletes the temp file
      end

      return url_path
    end

    class << self

    private

      def phantomjs_path
        File.join(options[:command_path] || '/usr/bin/', 'phantomjs')
      end
    end
  end
end

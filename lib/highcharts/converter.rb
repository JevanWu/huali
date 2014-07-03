require 'tempfile'

module Highcharts
  class Converter
    def self.options
      @@options ||= {}
    end

    def self.outfile_path
      '/tmp/sales_report.svg'
    end

    def self.run(chart_options)
      chart_options_file = Tempfile.new('chart_options')
      begin
        chart_options_file.write(chart_options)
        chart_options_file.flush
        system "#{phantomjs_path} #{File.expand_path('../highcharts-convert.js', __FILE__)} -infile #{chart_options_file.path} -outfile #{outfile_path} -type svg -constr Chart -width 1440"
      ensure
        chart_options_file.close
        chart_options_file.unlink   # deletes the temp file
      end
    end

    class << self

    private

      def phantomjs_path
        File.join(options[:command_path] || '/usr/bin/', 'phantomjs')
      end
    end
  end
end

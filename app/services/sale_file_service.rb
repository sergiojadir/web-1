require "csv"

class SaleFileService
  VALID_HEADER = [
    "purchaser name", "item description", "item price",
    "purchase count", "merchant address", "merchant name"
  ]

	def initialize(file)
		@file = file
		@path = "#{Rails.root}/tmp/sale_files/#{file.id}"
    @logger = Logger.new(STDOUT)
	end

	def import!
		csv_options = { :encoding => 'ISO-8859-1:UTF-8', :skip_blanks => true, headers: true, :col_sep => "\t" }
  	csv = CSV.read(get_file, csv_options)
		
    valid_header?(csv.headers)
    
    @logger.info("*** Importing... ***")
    
    begin
      GC.start

      csv.lazy.each do |params|
        sale = Sale.new
        sale.purchaser_name = "#{params['purchaser name']}"
        sale.item_description = params['item description']
        sale.item_price = params['item price']
        sale.purchase_count = params['purchase count']
        sale.merchant_address = params['merchant address']
        sale.merchant_name = params['merchant name']
        sale.sale_file_id = @file.id
        
        sale.save
      end

      GC.start
      FileUtils.rm_rf(@path)
      @logger.info("*** File successfully imported ***")
    rescue Exception => e
      FileUtils.rm_rf(@path)
      @logger.fatal("Error: #{e.message}")
    end
	end

	def get_file
		FileUtils.mkdir_p @path
		
		file_name = @file.file
		file = "#{@path}/#{file_name}"

		File.open(file, "wb") do | file|
  		file.write(@file.file.read)
	  	file.close
	 	end
		file
	end

  def valid_header?(file_header)
    return invalid_header(file_header) if file_header != VALID_HEADER
  end

  def invalid_header(file_header)
    @file.fire_events!(:falha)

    @logger.info("*** Arquivo importado com falha ***")
    raise "File with invalid header. Expected: #{HEADER_VALIDO}. File header: #{header_do_arquivo}"
  end
end
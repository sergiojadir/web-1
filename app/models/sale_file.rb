class SaleFile < ApplicationRecord
	# Constants
	VALID_HEADER = [
    "purchaser name", "item description", "item price",
    "purchase count", "merchant address", "merchant name"
  ]

	# Associations
	has_many :sales

	# File upload
	attachment :file

	# Validations
	validates :file, presence: true

	# Callbacks
	after_commit :process_file

	def import!
		sale_file_service = SaleFileService.new(self)
		lines = sale_file_service.read_lines
		file_service = FileService.new(sale_file_service.path)
    logger = Logger.new(STDOUT)

    logger.info("*** Importing... ***")

    # file_service.raise_invalid_extension unless file_service.text_plain_extension?
    sale_file_service.valid_header?(lines.headers, VALID_HEADER)
    
    begin
      GC.start

      lines.lazy.each do |params|
        sale = Sale.new
        sale.purchaser_name = "#{params['purchaser name']}"
        sale.item_description = params['item description']
        sale.item_price = params['item price']
        sale.purchase_count = params['purchase count']
        sale.merchant_address = params['merchant address']
        sale.merchant_name = params['merchant name']
        sale.sale_file_id = self.id
        
        sale.save
      end

      GC.start
      sale_file_service.remove_temp_file
      logger.info("*** File successfully imported ***")
    rescue Exception => e
      sale_file_service.remove_temp_file
      logger.fatal("Error: #{e.message}")
    end
	end

	private

	def process_file
		ProcessFileJob.perform_later(self.id)
	end
end
class Sale < ApplicationRecord
	# Associations
	belongs_to :sale_file

	# Instance methods
	def total_gross
		self.purchase_count * self.item_price
	end
end
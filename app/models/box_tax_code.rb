class BoxTaxCode < ApplicationRecord
  belongs_to :Country
  belongs_to :BoxInformation
  belongs_to :TaxCodeOperationSide
  belongs_to :TaxCodeOperationLocation
  belongs_to :TaxCodeOperationType
  belongs_to :TaxCodeOperationRate
end

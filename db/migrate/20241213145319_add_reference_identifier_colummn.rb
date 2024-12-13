class AddReferenceIdentifierColummn < ActiveRecord::Migration[6.1]
  def change
    add_column :entries, :reference_identifier, :string, index: true
  end
end

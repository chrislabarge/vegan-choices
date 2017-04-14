class RemoveCertifiedVeganFromItem < ActiveRecord::Migration[5.0]
  def change
    remove_column :items, :certified_vegan, :boolean
  end
end

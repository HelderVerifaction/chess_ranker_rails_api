class AddLinksToModels < ActiveRecord::Migration[6.1]
  def change
    add_reference :members, :club, index: true
  end
end

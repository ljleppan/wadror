class RenameStyleToOldStyleInBeers < ActiveRecord::Migration
  def change
    change_table :beers do |t|
      t.rename :style, :old_style
    end
  end
end

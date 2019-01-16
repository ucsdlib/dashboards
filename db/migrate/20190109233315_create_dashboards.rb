class CreateDashboards < ActiveRecord::Migration[5.1]
  def change
    create_table :dashboards do |t|
      t.string  :rdd_attribute 
      t.integer :rdd_value, :limit => 8
      t.timestamps
    end
  end
end

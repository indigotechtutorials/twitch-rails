class AddLiveToStreams < ActiveRecord::Migration[7.1]
  def change
    add_column :streams, :live, :boolean
  end
end

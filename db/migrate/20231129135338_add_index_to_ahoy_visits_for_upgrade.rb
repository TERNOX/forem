class AddIndexToAhoyVisitsForUpgrade < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    unless index_exists?(:ahoy_visits, [:visitor_token, :started_at])
      add_index :ahoy_visits, [:visitor_token, :started_at], algorithm: :concurrently
    end
  end
end

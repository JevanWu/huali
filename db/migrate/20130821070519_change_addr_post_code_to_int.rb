class ChangeAddrPostCodeToInt < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        #change type to integer
        execute <<-SQL
        ALTER TABLE addresses 
        ALTER COLUMN post_code 
        TYPE integer 
        USING CAST(CASE WHEN post_code ~ E'^\\d+$' THEN post_code ELSE NULL END AS INTEGER)
        SQL
      end

      dir.down do
        #change type back char(255)
        execute <<-SQL
        ALTER TABLE addresses
        ALTER COLUMN post_code 
        TYPE character varying(255) 
        SQL
      end
    end
  end
end

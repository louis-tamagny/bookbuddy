class AddPgTrgmExtensionToDb < ActiveRecord::Migration[7.1]
  execute "create extension pg_trgm;"
end

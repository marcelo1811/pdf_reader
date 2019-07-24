Setup:
  1- Create a database
    run createdb database_name to create, while your_username and your_password should be changed to your username and password for your local machine

  2- Config your database connection on database.yml file
  * Change or create env var file if necessary
Run app:
  bundle exec rackup -p 3000

Run console:
  racksh


Utils:
  1- Create a migration
    excute:
      rake db:create_migration NAME=create_table_name

    migration file:
      class CreateTableName < ActiveRecord::Migration
        def change
          create_table :table_name do |t|
            t.string :name, null: false, default: ""

            t.timestamps, null: false
          end

          add_index :resources, :name, unique: true
        end
      end

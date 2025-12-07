# This migration converts plain text password storage to bcrypt password_digest
# IMPORTANT: This is a one-way migration. Existing passwords will be hashed.
# Users with existing accounts will need to use password reset functionality.
class MigratePasswordToSecurePassword < ActiveRecord::Migration[8.0]
  def up
    # Add password_digest column
    add_column :users, :password_digest, :string
    
    # Migrate existing passwords (hash them with bcrypt)
    # Note: This requires bcrypt gem to be installed
    User.reset_column_information
    
    User.find_each do |user|
      # Skip if password is blank
      next if user.read_attribute(:password).blank?
      
      # Hash the existing plain text password
      user.update_column(:password_digest, BCrypt::Password.create(user.read_attribute(:password)))
    end
    
    # Remove old password column
    remove_column :users, :password
  end
  
  def down
    # This is a destructive migration - we cannot recover plain text passwords
    add_column :users, :password, :text
    
    # Set a temporary password for all users
    User.reset_column_information
    User.update_all(password: "MIGRATED_PASSWORD_RESET_REQUIRED")
    
    remove_column :users, :password_digest
  end
end

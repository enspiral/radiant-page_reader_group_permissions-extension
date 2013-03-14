class CreateGroups < ActiveRecord::Migration
  def self.up
    User.send :has_and_belongs_to_many, :groups
    Page.send :belongs_to, :group

    create_table(:groups_users, :id => false) do |t|
      t.integer :group_id, :user_id
    end
    add_index :groups_users, :group_id
    add_index :groups_users, :user_id
    
    add_column :pages, :group_id, :integer
    
    #Add a default group to own the home page
    Group.reset_column_information
    Page.reset_column_information
    
    g = Group.create(:name => 'Site Editors')
    p = Page.find_by_parent_id(nil)
    if p
      p.group = g
      p.save
    end
  end

  def self.down
    remove_column :pages, :group_id
    drop_table :groups
    drop_table :groups_users
  end
end

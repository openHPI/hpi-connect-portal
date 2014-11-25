require_relative '20131217080552_create_bootsy_images.bootsy.rb'

class DropBootsyImages < ActiveRecord::Migration
  def change
    revert CreateBootsyImages
  end
end

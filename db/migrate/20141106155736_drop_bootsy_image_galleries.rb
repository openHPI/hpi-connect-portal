require_relative '20131217080553_create_bootsy_image_galleries.bootsy.rb'

class DropBootsyImageGalleries < ActiveRecord::Migration
  def change
    revert CreateBootsyImageGalleries
  end
end

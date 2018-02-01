module MockCarrierWave
  def self.included(base)
    base.before :each do
      allow_any_instance_of(ItemPhotoUploader).to receive(:store_dir) { 'tmp/capybara' }
      allow_any_instance_of(ItemPhotoUploader).to receive_message_chain(:thumb, :url) { '/images/no-img.jpeg' }
      allow_any_instance_of(CarrierWave::Uploader::Base).to receive(:store!).and_return nil
      allow_any_instance_of(CarrierWave::Uploader::Base).to receive(:remove!).and_return nil
    end
  end
end

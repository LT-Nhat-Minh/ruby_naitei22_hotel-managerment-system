RSpec.shared_context "users setup", shared_context: :metadata do
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, role: :admin) }
end

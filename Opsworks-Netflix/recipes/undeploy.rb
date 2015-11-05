# Run this to clean up docker resources
# This should prevent docker port conflicts

service 'docker' do
  supports :status => true, :restart => true, :reload => true
  action [:stop]
end


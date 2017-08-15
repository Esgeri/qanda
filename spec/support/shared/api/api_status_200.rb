shared_examples_for 'API Status 200' do
  it 'returns 200 status' do
    expect(response).to be_success
  end
end

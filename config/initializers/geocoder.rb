Geocoder.configure(
  lookup: :bing,
  api_key: ENV['SCHOOLS_BING_KEY'] || (raise RuntimeError, 'Please set envvar SCHOOLS_BING_KEY for geocoding')
)

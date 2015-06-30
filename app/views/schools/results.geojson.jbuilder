json.type 'FeatureCollection'
json.features @schools do |school|
  json.merge! feature_json(school)
end

push_dokku:
	git push dokku master

invalidate_cloudfront_cache:
	aws cloudfront create-invalidation --distribution-id EIJAI3FE592YV --paths '/*'

deploy: push_dokku invalidate_cloudfront_cache
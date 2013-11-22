.PHONY: todo fix

todo:
	@grep -e 'TODO.*' -n --color=always -R app/ spec/

fix:
	@grep -e 'FIX.*' -n --color=always -R app/ spec/

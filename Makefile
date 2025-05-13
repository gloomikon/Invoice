generate:
	xcodegen generate

open: generate
	open Invoice.xcodeproj

clean:
	rm -rf ~/Library/Developer/Xcode/DerivedData/Invoice*

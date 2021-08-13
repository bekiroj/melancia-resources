languages = {
	"Turkce",
}
	
flags = {
	"tr",
}


function getLanguageName(language)
	return languages[language] or 'Turkce'
end

function getLanguageCount()
	return #languages
end

function getLanguageList()
	return languages
end
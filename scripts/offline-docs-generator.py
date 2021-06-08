'''
This is the program for Generator for offline documentation
more about which can be found out at https://github.com/opencax/GSoC/issues/6
and the GSOC project details for the same are present at
https://summerofcode.withgoogle.com/projects/#6746958066089984

'''
import urllib.request, urllib.parse, urllib.error, urllib.request, urllib.error, urllib.parse, os
from bs4 import BeautifulSoup as bs,Comment

url = 'https://en.wikibooks.org/wiki/OpenSCAD_User_Manual'
url_wiki = 'https://en.wikibooks.org'
url_openscadwiki = '/wiki/OpenSCAD_User_Manual'
url_api = 'https://en.wikibooks.org/w/api.php?action=parse&format=xml&prop=text&page='
url_api_openscad = 'https://en.wikibooks.org/w/api.php?action=parse&format=xml&prop=text&page=OpenSCAD_User_Manual/'

this_dir = os.path.abspath('')
dir_docs = 'openscad_docs'
dir_imgs =  os.path.join( dir_docs, 'imgs')
dir_maths =  os.path.join( dir_docs, 'imgs','maths')
dir_styles =  'styles'
dir_styles_full = os.path.join( dir_docs, 'styles')

#Create the directories to save the doc they don't exist
if not os.path.exists(dir_docs): os.makedirs(dir_docs)
if not os.path.exists(dir_imgs): os.makedirs(dir_imgs)
if not os.path.exists(dir_maths): os.makedirs(dir_maths)	
if not os.path.exists(dir_styles_full): os.makedirs(dir_styles_full)

pages =[]
imgs  =[]
maths =[]

def sureUrl(url):
	'''
	This function generates the complete url after getting urls form src
	/wiki/OpenSCAD_User_Manual get converted to https://en.wikibooks.org/wiki/OpenSCAD_User_Manual

	'''
	if url.startswith('//'):
		url = 'https:'+url
	elif not url.startswith( url_wiki ):
		url = urllib.parse.urljoin( url_wiki, url[0]=="/" and url[1:] or url)
	return url

def getTags():
	'''
	This function handles the different tags present in the HTML document
	for example the image tags

	'''
	pass

def getMaths():
	'''
	This function generates the image version of the math formulas
	to be displayed in various HTML files, for example
	https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Mathematical_Operators
	and saves them to the directory /openscad_docs/imgs/maths

	'''
	pass

def getImages():
	'''
	This function generates the images present the in HTML documents
	and saves them to the directory /openscad_docs/imgs

	'''
	pass

def getFooter( url, name ):
	'''
	This function generates the Footer with the license attribution for all the pages

	'''
	footer = (f'''<footer class='mw-body' style="font-size:13px;color:darkgray;text-align:center;margin-bottom:-1px">
	From the WikiBooks article <a style="color:black" href="{url}">{name}</a> 
	(provided under <a style="color:black" href="https://creativecommons.org/licenses/by-sa/3.0/">
	CC-BY-SA-3.0</a>)</footer>''')

	return bs(footer,'html.parser')

def getPages( url=url,folder=dir_docs ):
	'''
	This is the main function of the program
	which generates the HTML document from the given url
	and calls different functions to generate the Offline
	version of the page and save it under the directory /openscad_docs
	
	'''
	url = sureUrl(url)
	if url.split("#")[0] not in pages:
		pages.append( url.split("#")[0] )							#add the url to the `pages` list so that they don't get downloaded again
		wiki_url = url
		url = url.replace(url_wiki+'/wiki/', "")
		url = url_api + url

		request = urllib.request.Request(url)
		request.add_header('User-Agent','Generator-for-Offline-Documentation (https://github.com/abshk-jr ; https://github.com/opencax/GSoC/issues/6 ; https://summerofcode.withgoogle.com/projects/#6746958066089984) urllib/3.9.0 [BeautifulSoup/4.9.0]')
		response = urllib.request.urlopen(request)
		xml = response.read()
		soup = bs(xml, 'lxml')
		soup = soup.text
		soup = bs(soup,'html5lib')

		fname = url.split("=")[-1]
		fname = fname.replace("OpenSCAD_User_Manual/","")
		if('#' in fname):											#for fnames like openscad_docs\FAQ#What_are_those_strange_flickering_artifacts_in_the_preview?.html
			fname = fname.split('#')[0]
		fname = fname.split("/")[-1]

		title = soup.new_tag("title")								#to add title to the pages
		title.string = fname.replace("_" , " ")
		soup.html.head.append(title)

		h1_tag = bs(f'<h1 class="firstHeading" id="firstHeading">{title.string}</h1>','html.parser')
		soup.body.insert(0,h1_tag)

		soup.body.append( getFooter( wiki_url, title.text ))

		fname = fname + ".html"
		filepath = os.path.join( folder, fname)

		print("Saving: ", filepath)
		open(filepath, "w", encoding="utf-8").write( str(soup) )



if(__name__ == '__main__'):
	getPages(url)
	print("Total number of pages generated is \t:\t", len(pages))
	print("Total number of images generated is \t:\t", len(imgs))
	print("Total number of math-images generated is:\t", len(maths))

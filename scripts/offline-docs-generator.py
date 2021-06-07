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

if not os.path.exists(dir_docs): os.makedirs(dir_docs)
if not os.path.exists(dir_imgs): os.makedirs(dir_imgs)
if not os.path.exists(dir_maths): os.makedirs(dir_maths)	
if not os.path.exists(dir_styles_full): os.makedirs(dir_styles_full)

pages =[]
imgs  =[]
styles=[]
maths =[]

def sureUrl(url):
	if url.startswith('//'):
		url = 'https:'+url
	elif not url.startswith( url_wiki ):
		url = urllib.parse.urljoin( url_wiki, url[0]=="/" and url[1:] or url)
	return url

def getPage( url=url,folder=dir_docs ):
	url = sureUrl(url)
	if url.split("#")[0] not in pages:
		pages.append( url.split("#")[0] )
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

		fname = fname + ".html"
		filepath = os.path.join( folder, fname)


		print("Saving: ", filepath)
		open(filepath, "w", encoding="utf-8").write( str(soup) )



if(__name__ == '__main__'):
	getPage(url)
	print("# of pages: ", len(pages))
	print("# of styles: ", len(styles))
	print("# of imgs: ", len(imgs))
	print("# of maths: ", len(maths))
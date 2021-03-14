#!/usr/bin/env python
# _*_ coding: utf8 _*_

# Andreas Müller, 2008
# andrmuel@ee.ethz.ch
#
# this code may be freely used under GNU GPL conditions

"""
convert flow graph dump to dot input
"""

import sys,re

class Dump2dot:
	def __init__(self,inputfile,outputfile,drawports=True):
		self.infile    = open(inputfile,'r')
		self.outfile   = open(outputfile,'w')
		self.drawports = drawports
		self.header    = "digraph flowgraph\n{\n\tnode [shape=box];\n\tedge [labelfontsize=12, arrowsize=0.6];\n\n"
		self.footer    = "}\n"
		self.re_block  = re.compile("^ +block: (?P<name>[a-z0-9_]+)\((?P<nr>[0-9]+)\)$",re.IGNORECASE)
		self.re_edge   = re.compile("^ +edge: (?P<src_name>[a-z0-9_]+)\((?P<src_nr>[0-9]+)\)(:(?P<src_port>[0-9]+))->(?P<dst_name>[a-z0-9_]+)\((?P<dst_nr>[0-9]+)\)(:(?P<dst_port>[0-9]+))?$",re.IGNORECASE)

	def parse_input(self):
		self.blocks = []
		self.edges = []
		for line in self.infile:
			block = self.re_block.match(line)
			edge = self.re_edge.match(line)
			if block:
				self.blocks.append({'nr':block.group("nr"), 'name':block.group("name")})
			elif edge:
				self.edges.append({'src_nr':edge.group("src_nr"),'dst_nr':edge.group("dst_nr"),'src_port':edge.group("src_port"),'dst_port':edge.group("dst_port")})
		self.blocks.sort(key=lambda x: int(x['nr']))
		self.edges.sort(key=lambda x: int(x['src_nr']))

	def write_output(self):
		self.outfile.write(self.header)
		for block in self.blocks:
			self.outfile.write("\tn" + block['nr'] + " [label=" + block['name'] + "];\n")
		self.outfile.write("\n")
		for edge in self.edges:
			tl = len([e for e in self.edges if e['src_nr']==edge['src_nr']])>1 # more than one outgoing edge at source?
			hl = len([e for e in self.edges if e['dst_nr']==edge['dst_nr']])>1 # more than one incoming edge at dest?
			self.outfile.write("\tn"+edge['src_nr']+" -> n"+edge['dst_nr']+" ["*(tl or hl)+("taillabel="+edge['src_port'])*tl+(", "*tl+"headlabel="+edge['dst_port'])*hl+"]"*(tl or hl)+";\n")
		self.outfile.write(self.footer)

	def close_files(self):
		self.infile.close()
		self.outfile.close()


if __name__=='__main__':
	if len(sys.argv)<2:
		print "Usage: "+sys.argv[0]+" inputfile [outputfile]" 
		sys.exit(1)
	if len(sys.argv)==2:
		dump2dot = Dump2dot(sys.argv[1],sys.argv[1].split(".")[0]+".dot")
	else:
		dump2dot = Dump2dot(sys.argv[1],sys.argv[2])

	dump2dot.parse_input()
	dump2dot.write_output()
	dump2dot.close_files()




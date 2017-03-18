#!/usr/bin/python

from xml.etree import ElementTree
from collections import namedtuple
import optparse
import base64
import md5
import os
import sys

# Parse options
parser = optparse.OptionParser()
parser.add_option("--device", type="string", dest="device_type", help="Device Type. (Has to match the LVFPGA target plugin)", default=None)
parser.add_option("--input-bin", type="string", dest="input_bin", help="Path to bin file that needs to be merged with the LVBITX before exporting", default=None)
parser.add_option("--output-bin", type="string", dest="output_bin", help="Create a binary configuration bitstream", default=None)
parser.add_option("--output-lvbitx", type="string", dest="output_lvbitx_path", help="Output path for autogenerated LVBITX file", default=None)
parser.add_option("--output-src-path", type="string", dest="output_src_path", help="Output path for autogenerated src file", default=None)
(options, args) = parser.parse_args()

# Args
if (len(args) < 1):
	print 'ERROR: Please specify the input LVBITX file name'
	parser.print_help()
	sys.exit(1)

lvbitx_filename = args[0]
input_filename = os.path.abspath(lvbitx_filename)

if (not os.path.isfile(input_filename)):
	print 'ERROR: LVBITX File ' + input_filename + ' could not be accessed or is not a file.'
	parser.print_help()
	sys.exit(1)
if (options.input_bin is not None and not os.path.isfile(os.path.abspath(options.input_bin))):
	print 'ERROR: FPGA Bin File ' + options.input_bin + ' could not be accessed or is not a file.'
	parser.print_help()
	sys.exit(1)
if (options.output_lvbitx_path is not None and input_filename == options.output_lvbitx_path):
	print 'ERROR: Input and output LVBITX files were the same. Choose a difference input or output file.'
	parser.print_help()
	sys.exit(1)

# Get XML Tree Node
tree = ElementTree.parse(input_filename)
root = tree.getroot()

# Update device type
if (options.device_type is not None):
	root.find('Project').find('TargetClass').text += '; ' + options.device_type

# Merge bitstream into LVBITX
if (options.input_bin is not None):
	with open(os.path.abspath(options.input_bin), 'rb') as bin_file:
		bitstream = bin_file.read()
		bitstream_md5 = md5.new(bitstream).hexdigest()
		bitstream_b64 = base64.b64encode(bitstream)
		bitstream_b64_lb = ''
		for i in range(0, len(bitstream_b64), 76):
			bitstream_b64_lb += bitstream_b64[i:i+76] + '\n'

		root.find('Bitstream').text = bitstream_b64_lb
		root.find('BitstreamMD5').text = bitstream_md5

# Write BIN file
bitstream = base64.b64decode(root.find('Bitstream').text)
if (options.output_lvbitx_path is not None and md5.new(bitstream).hexdigest() != root.find('BitstreamMD5').text):
	print 'ERROR: The MD5 sum for the output LVBITX was incorrect. Make sure that the bitstream in the input LVBITX or BIN file is valid.'
	sys.exit(1)
if (options.output_bin is not None):
	fpga_bin_file = open(options.output_bin, 'w')
	fpga_bin_file.write(bitstream)
	fpga_bin_file.close()
	
# Save LVBITX
if (options.output_lvbitx_path is not None):
	tree.write(options.output_lvbitx_path, encoding="utf-8", xml_declaration=True, default_namespace=None, method="xml")
	

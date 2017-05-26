# coding: utf-8

# Python scripts to generate verilog lines toa  file tmp.txt. These will write all
# the necessary code to a file tmp.txt. You can then copy paste the code in from tmp.txt
# to the Verilog files. It's not the prettiest, but it works. There's a brief description
# of where to put each line, I've also put approximate line numbers, but these can change
# slightly so use them as a rule of thumb. I've also commented in a keyword "Search" -- this just
# means if you search for whatever the keyword is in the relevant file, you'll arrive at the appropriate
# section.

# Generate 32 bit wires.
with open("tmp.txt", "w+") as f:
    for i in range(30, 50):
        f.write("llr_reg{0}_val, ".format(i))
with open("tmp.txt", "w+") as f:
    for i in range(20, 50):
        f.write(".codeword{0}(llr_reg{0}_val), ".format(i))
with open("tmp.txt", "w+") as f:
    for i in range(1, 50):
        s = "setting_reg #(.my_addr(SR_LLR_REG{0}), .awidth(8), .width(16)) sr_llr_reg{0}\n\t(.clk(radio_clk), .rst(radio_rst), .strobe(set_stb), .addr(set_addr), .in(set_data),\n\t.out(llr_reg{0}_val), .changed());\n\n".format(i)
        f.write(s)

with open("tmp.txt", "w+") as f:
    c = 184
    for i in range(20, 50):
        if c not in no_use:
            s = "localparam SR_LLR_REG{0}\t= 8'd{1};\n".format(i, c)
            c = c+1
        else:
            c = c+1
            s = "localparam SR_LLR_REG{0}\t= 8'd{1};\n".format(i, c)
        f.write(s)
# %load 54-57
with open("tmp.txt", "w+") as f:
    for i in range(20, 50):
        f.write("phase_acc{0}, ".format(i))
    f.write("\n")
with open("tmp.txt", "a+") as f:
    for i in range(20, 50):
        f.write("freq{0}, ".format(i))
    f.write("\n")
with open("tmp.txt", "a+") as f:
    for i in range(20, 50):
        f.write("amp{0}, ".format(i))
    f.write("\n")
with open("tmp.txt", "a+") as f:
    for i in range(20, 50):
        f.write("ph{0}, ".format(i))
    f.write("\n")
with open("tmp.txt", "w+") as f:
    for i in range(20, 50):
        s = "freq{0} = codeword{0}[15:0];\namp{0} = codeword{0}[23:16];\ntmp = codeword{0}[31:24];\nph{0} = tmp << 3;\n\n"
        f.write(s)
get_ipython().magic('load 62')
# %load 62
with open("tmp.txt", "w+") as f:
    for i in range(20, 50):
        s = "freq{0} = codeword{0}[15:0];\namp{0} = codeword{0}[23:16];\ntmp = codeword{0}[31:24];\nph{0} = tmp << 3;\n\n".format(i)
        f.write(s)
# %load 62
with open("tmp.txt", "w+") as f:
    for i in range(20, 50):
        s = "phase_acc{0} = phase_acc{0} + freq{0};\n".format(i)
        f.write(s)
# %load 62
with open("tmp.txt", "w+") as f:
    for i in range(20, 50):
        s = "amp{0}*sine[phase_acc{0}[15:5] + ph{0}] + ".format(i)
        f.write(s)

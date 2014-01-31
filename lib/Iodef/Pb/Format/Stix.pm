##################################################################################################################################
#Copyright 2013 Carnegie Mellon University
#
#This material is based upon work funded and supported by Department of Homeland Security under 
#Contract No. FA8721-05-C-0003 with Carnegie Mellon University for the operation of the Software Engineering Institute,
#a federally funded research and development center sponsored by the United States Department of Defense.
#
#Any opinions, findings and conclusions or recommendations expressed in this material are those of the author(s) 
#and do not necessarily reflect the views of Department of Homeland Security or the United States Department of Defense.
#
#References herein to any specific commercial product, process, or service by trade name, trade mark, manufacturer, or otherwise,
#does not necessarily constitute or imply its endorsement, recommendation, or favoring by Carnegie Mellon University 
#or its Software Engineering Institute.
#
#NO WARRANTY. THIS CARNEGIE MELLON UNIVERSITY AND SOFTWARE ENGINEERING INSTITUTE MATERIAL IS FURNISHED ON AN "AS-IS" BASIS.
#CARNEGIE MELLON UNIVERSITY MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED, AS TO ANY MATTER INCLUDING,
#BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE OF THE MATERIAL.
#CARNEGIE MELLON UNIVERSITY DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT TO FREEDOM FROM PATENT, TRADEMARK,
#OR COPYRIGHT INFRINGEMENT.
#
#This material has been approved for public release and unlimited distribution.
#
#Carnegie Mellon(R) is registered in the U.S. Patent and Trademark Office by Carnegie Mellon University.
#
#DM-0000800
##################################################################################################################################
package Iodef::Pb::Format::Stix;
use base 'Iodef::Pb::Format';

use IPC::Run qw(run);
use strict;
use warnings;
require JSON::XS;

sub write_out{
    my $self = shift;
    my $args = shift;

    my $array = $self->to_keypair($args);
    my @json_stream;
    push(@json_stream,JSON::XS::encode_json($_)) foreach(@$array);
    
    my $json_text = join("\n",@json_stream);
    my $search_param = $args->{'query'};
 
    my @cmd;
    #full path to the Python module - cif-json2stix.py, or just name of the Python module if it's installed
    my $pythonmodule = '';
    my $outfile;

	#uncomment this if the python module is not installed yet
    #push(@cmd,'python2.6');#for testing
    push(@cmd,$pythonmodule);
    push(@cmd,'-');
    push(@cmd,$json_text);#AS INPUT
    push(@cmd,$search_param);#CIF query search parameter
    
    run \@cmd,'>', \$outfile;

    return $outfile;
}

1;

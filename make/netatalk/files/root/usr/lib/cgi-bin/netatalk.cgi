#!/bin/sh

PATH=/bin:/usr/bin:/sbin:/usr/sbin
. /usr/lib/libmodcgi.sh

check "$NETATALK_ENABLED" yes:auto "*":man

sec_begin '$(lang de:"Starttyp" en:"Start type")'

cat << EOF
<p>
<input id='e1' type='radio' name='enabled' value='yes'$auto_chk><label for='e1'>$(lang de:"Automatisch" en:"Automatic")</label>
<input id='e2' type='radio' name='enabled' value='no'$man_chk><label for='e2'>$(lang de:"Manuell" en:"Manual")</label>
</p>
EOF

sec_end
sec_begin '$(lang de:"Einstellungen" en:"Settings")'

cat << EOF
<ul>
<li><a href='$(href file netatalk afpd_conf)'>$(lang de:“Netatalk 3 Konfiguration“ en:“Netatalk 3 config“) (afp.conf)</a></li>
</ul>
EOF

sec_end
sec_begin '$(lang de:"Benutzer" en:"Users")'

cat << EOF
<p>
$(lang de:"Benutzer werden wie folgt angelegt und persistent gespeichert" en:"Create and persistently save users as follows"):
</p>
<ol>
<li>adduser -g 'Homer Simpson' hsimpson</li>
<li>modusers save</li>
<li>modsave flash</li>
</ol>
EOF

sec_end


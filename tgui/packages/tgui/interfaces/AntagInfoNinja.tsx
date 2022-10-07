import { useBackend, useLocalState } from '../backend';
import { Blink, BlockQuote, Box, Dimmer, Icon, Section, Stack } from '../components';
import { BooleanLike } from 'common/react';
import { Window } from '../layouts';

const ninja_green = {
  color: 'lightgreen',
  fontWeight: 'bold',
};

const ninja_quote = {
  color: 'teal',
};

type Objective = {
  count: number;
  name: string;
  explanation: string;
  complete: BooleanLike;
  was_uncompleted: BooleanLike;
  reward: number;
}

type Info = {
  objectives: Objective[];
};

export const AntagInfoNinja = (props, context) => {
  return (
    <Window
      width={620}
      height={900}
      theme="syndicate">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow>
            <Section scrollable fill>
              <Stack vertical>
                <Stack.Item textColor="red" fontSize="20px">
                  I am the Space Ninja!
                </Stack.Item>
                <Stack.Item>
                  <ObjectivePrintout />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section fill title="Abilities">
              <Stack vertical fill>
                <Stack.Item grow>
                  I carry a number of weapons and suit functions to complete my mission.<br />

                  <span style={ninja_green}>
                    Gloves:
                  </span><br />
                  My gloves may be toggled on or off in order to hack into devices, stun enemies,
                  or recharge my main power cell via touching APCs and wires.<br />
                  I will require these gloves to complete my mission.<br /><br />

                  <span style={ninja_green}>
                    Stealth:
                  </span><br />
                  My suit is capable of entering a nearly invisible state at will,
                  this allows me to avoid detection and evade enemies that may detect me.<br />

                  <span style={ninja_green}>
                    Suit Weapons:
                  </span><br />
                  I have a number of throwing stars and energy nets at my disposal.<br />
                  The throwing stars harm and can weaken a limb should I strike them in the arms and legs.<br />
                  The nets can contain a foe and prevent their escape.<br />

                  <span style={ninja_green}>
                    EMP & Smoke:
                  </span><br />
                  I am capable of activating a EM pulse that will disable electronics in the nearby area.<br />
                  No less useful is my collection of smoke grenades to cover my advance.<br />

                  <span style={ninja_green}>
                    Repair Nanopaste:
                  </span><br />
                  Should I be wounded or at risk of capture, I can activate the nanomachines in my suit.<br />
                  These will rapidly regenerate my injuries and prevent my body from surrendering.<br />
                  However, each usage will cause cellular damage to my body and damage my DNA. I must use it well.<br />
                  <br />
                  My <span style={ninja_green}>High-Frequency Blade</span> is my most powerful tool.<br />
                  It has a number of functions that allow me to slay foes and remain living in combat.<br /><br />

                  <span style={ninja_green}>
                    Fuel Cell:
                  </span><br />
                  While wielding my blade in both hands, my strikes regenerate the fuel cell on my suit.<br />
                  When full, I may use my Repair Nanopaste ability again.<br />

                  <span style={ninja_green}>
                    Critical Damage:
                  </span><br />
                  When striking an enemy, I deal more damage to them depending on the distance of my strikes.<br />
                  Rapidly striking a foe in the same location will deal a minimum of damage,<br />
                  while striking from one corner to the opposite corner of their body deals the most damage.<br />
                  <span style={ninja_quote}>
                    Have you ever slashed a soul to ribbons?<br />
                  </span><br />

                  <span style={ninja_green}>
                    Ninja Run:
                  </span><br />
                  While holding my blade in one hand, I am capable of deflecting most projectiles fired at me.<br />
                  I am also able to jump rapidly to any visible location.<br />
                  However, I am unable to strike foes while Ninja Running due to the intense focus it requires.<br />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const ObjectivePrintout = (props, context) => {
  const { data } = useBackend<Info>(context);
  const {
    objectives,
  } = data;
  return (
    <Stack vertical>
      <Stack.Item bold>
        The Spider Clan has given you the following tasks:
      </Stack.Item>
      <Stack.Item>
        {!objectives && "None!"
        || objectives.map(objective => (
          <Stack.Item key={objective.count}>
            #{objective.count}: {objective.explanation}
          </Stack.Item>
        )) }
      </Stack.Item>
    </Stack>
  );
};

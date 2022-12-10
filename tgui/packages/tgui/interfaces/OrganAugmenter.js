import { toFixed } from 'common/math';
import { useBackend } from '../backend';
import { Box, Button, Flex, Icon, LabeledList, NoticeBox, Section, Stack, Table } from '../components';
import { Window } from '../layouts';

export const InsertedOrganNode = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    stability_usage,
    node_name,
    node_desc,
    node_icon,
    working,
    held_organ_node,
  } = data;

  if (!held_organ_node) {
    return (
      (!working && (
        <NoticeBox
          info>
          Please insert a organ node.
        </NoticeBox>
      ))
    );
  }

  return (
    <Section
      title="Inserted Node"
      buttons={
        <>
          <Button
            icon="syringe"
            disabled={!!working}
            color={"good"}
            onClick={() => act("splice")}
            content="Splice" />
          <Button
            icon="eject"
            disabled={!!working}
            onClick={() => act("eject_node")}
            content="Eject Node" />
        </>
      }>
      <Stack fill align="center">
        <Stack.Item>
          <Icon m={1} size={3} name={node_icon} />
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <LabeledList>
            <LabeledList.Item
              label="Organ Node">
              <Box
                bold>{node_name}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item
              label="Description">
              <Box
                italic>
                {node_desc}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item
              label="Stabilty Usage">
              <Icon
                name="brain"
                width="15px"
                textAlign="center"
              /> {stability_usage}
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const ImplantedOrganNodes = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    stability_used,
    stability_max,
    working,
  } = data;

  const current = data.current || [];

  if (!organ_name) {
    return (
      (!working && (
        <NoticeBox
          info>
          Please insert an organ.
        </NoticeBox>
      ))
    );
  }
  return (
    <Section
      title="Implanted Organ Nodes"
      buttons={
        <Button
          icon="eject"
          disabled={!!working}
          onClick={() => act("eject_organ")}
          content="Eject Organ" />
      }>
      {!current.length && "No nodes detected."}
      {!!current.length && (
        <Table>
          <Table.Row
            header>
            <Table.Cell>
              Node
            </Table.Cell>
            <Table.Cell
              textAlign="center">
              <Button
                color="transparent"
                icon="brain"
                tooltip="Used Stability"
                tooltipPosition="top"
                content={stability_used + "/" + stability_max} />
            </Table.Cell>
            <Table.Cell
              textAlign="center">
              <Button
                color="transparent"
                icon="check"
                tooltip="Has Partner"
                tooltipPosition="top" />
            </Table.Cell>
          </Table.Row>
          {current.map(node => (
            <Table.Row
              key={node.ref}>
              <Table.Cell>
                <Button
                  textAlign="center"
                  width="18px"
                  mr={1}
                  color="transparent"
                  icon={node.icon}
                  tooltip={node.desc}
                  tooltipPosition="top" />
                {node.name}
              </Table.Cell>
              <Table.Cell
                bold
                color={("good")}
                textAlign="center">
                {node.stability}
              </Table.Cell>
              <Table.Cell
                textAlign="center">
                <Icon
                  name={node.active ? "check" : "times"}
                  color={node.active ? "good" : "bad"} />
              </Table.Cell>
            </Table.Row>))}
        </Table>
      )}
    </Section>
  );
};

export const TimeFormat = (props, context) => {
  const { value } = props;

  const seconds = toFixed(Math.floor((value/10) % 60)).padStart(2, "0");
  const minutes = toFixed(Math.floor((value/(10*60)) % 60)).padStart(2, "0");
  const hours = toFixed(Math.floor((value/(10*60*60)) % 24)).padStart(2, "0");
  const formattedValue = `${hours}:${minutes}:${seconds}`;
  return formattedValue;
};

export const OrganAugmenter = (props, context) => {
  const { data } = useBackend(context);
  const {
    working,
    timeleft,
    error,
  } = data;
  return (
    <Window
      title="Organ Augmenter"
      width={500}
      height={500}>
      <Window.Content>
        {!!error && (
          <NoticeBox>
            {error}
          </NoticeBox>
        )}
        {!!working && (
          <NoticeBox
            danger>
            <Flex
              direction="column">
              <Flex.Item
                mb={0.5}>
                Operation in progress.
              </Flex.Item>
              <Flex.Item>
                Time Left: <TimeFormat value={timeleft} />
              </Flex.Item>
            </Flex>
          </NoticeBox>
        )}
        <InsertedOrganNode />
        <ImplantedOrganNodes />
      </Window.Content>
    </Window>
  );
};

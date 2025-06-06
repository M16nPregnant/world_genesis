import { decodeHtmlEntities } from 'common/string';
import { useBackend } from '../backend';
import { Box, Button, NoticeBox, Section, LabeledList } from '../components';
import { Window } from '../layouts';

export const RemoteRobotControl = (props, context) => {
  return (
    <Window
      title="Remote Robot Control"
      width={500}
      height={500}>
      <Window.Content scrollable>
        <RemoteRobotControlContent />
      </Window.Content>
    </Window>
  );
};

export const RemoteRobotControlContent = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    robots = [],
    commandeering,
  } = data;
  if (!robots.length) {
    return (
      <Section>
        <NoticeBox textAlign="center">
          No robots detected
        </NoticeBox>
      </Section>
    );
  }
  return robots.map(robot => {
    return (
      <Section
        key={robot.ref}
        title={robot.name + " (" + robot.model + ")"}
        buttons={(
          <>
            <Button
              icon="tools"
              content="Interface"
              onClick={() => act('interface', {
                ref: robot.ref,
              })} />
            <Button
              icon="phone-alt"
              content="Call"
              selected={robot.ref === commandeering}
              onClick={() => act('callbot', {
                ref: robot.ref,
              })} />
          </>
        )}>
        <LabeledList>
          <LabeledList.Item label="Status">
            <Box inline color={decodeHtmlEntities(robot.mode) === "Inactive"
              ? 'bad'
              : decodeHtmlEntities(robot.mode) === "Idle"
                ? 'average'
                : 'good'}>
              {decodeHtmlEntities(robot.mode)}
            </Box>
            {' '}
            {robot.hacked && (
              <Box inline color="bad">
                (HACKED)
              </Box>
            ) || "" }
          </LabeledList.Item>
          <LabeledList.Item label="Location">
            {robot.location}
          </LabeledList.Item>
        </LabeledList>
      </Section>
    );
  });
};

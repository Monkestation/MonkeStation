import { map, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { toFixed } from 'common/math';
import { pureComponentHooks } from 'common/react';
import { Component, Fragment } from 'inferno';
import { Box, Button, Chart, ColorBox, Flex, Icon, LabeledList, ProgressBar, Section, Stack, Table } from '../components';
import { Window } from '../layouts';
import { useBackend, useLocalState } from '../backend';


export const RbmkStats = () => {
  return (
    <Window width={450} height={550} theme="ntos" title="Reactor Monitor">
      <Window.Content>
        <RbmkStatsContent />
      </Window.Content>
    </Window>
  );
};

export const RbmkStatsContent = (props, context) => {
  const { act, data } = useBackend(context);
  const powerData = data.powerData.map((value, i) => [i, value]);
  const pressureData = data.pressureData.map((value, i) => [i, value]);
  const tempInputData = data.tempInputData.map((value, i) => [i, value]);
  const tempOutputdata = data.tempOutputdata.map((value, i) => [i, value]);

  return (
    <Section>
      <Stack>
        <Stack.Item width="450px">
          <Section title="Reactor Metrics">
            <LabeledList>

              <LabeledList.Item label="Reactor Power">
                <ProgressBar
                  value={data.power}
                  minValue={0}
                  maxValue={100}
                  ranges={{
                    good: [40, 70],
                    average: [0, 40],
                    bad: [70, Infinity],
                  }}>
                  {toFixed(data.power) + ' (%)'}
                </ProgressBar>
              </LabeledList.Item>

              <LabeledList.Item label="Reactor Pressure">
                <ProgressBar
                  value={data.reactorPressure}
                  minValue={0}
                  maxValue={10000}
                  ranges={{
                    good: [1000, 8000],
                    average: [0, 1000],
                    bad: [8000, Infinity],
                  }}>
                  {toFixed(data.reactorPressure) + ' (kPa)'}
                </ProgressBar>
              </LabeledList.Item>

              <LabeledList.Item label="Coolant Temperature">
                <ProgressBar
                  value={data.coolantInput}
                  minValue={-273.15}
                  maxValue={1000}
                  ranges={{
                    good: [-Infinity, 0],
                    average: [0, 200],
                    bad: [200, Infinity],
                  }}>
                  {toFixed(data.coolantInput) + ' (C°)'}
                </ProgressBar>
              </LabeledList.Item>

              <LabeledList.Item label="Outlet Temperature">
                <ProgressBar
                  value={data.coolantOutput}
                  minValue={-273.15}
                  maxValue={1000}
                  ranges={{
                    good: [0, 800],
                    average: [-273.15, 0],
                    bad: [800, 1000],
                  }}>
                  {toFixed(data.coolantOutput) + ' (C°)'}
                </ProgressBar>
              </LabeledList.Item>

            </LabeledList>
          </Section>

          <Section title="Power Statistics:" height="100px">
            <Chart.Line
              fillPositionedParent
              data={powerData}
              rangeX={[0, powerData.length - 1]}
              rangeY={[0, 100]}
              strokeColor="rgba(255, 215,0, 1)"
              fillColor="rgba(255, 215, 0, 0.1)" />
          </Section>

          <Section title="Pressure Statistics:" height="100px">
            <Chart.Line
              fillPositionedParent
              data={pressureData}
              rangeX={[0, pressureData.length - 1]}
              rangeY={[0, 7000]}
              strokeColor="rgba(255,250,250, 1)"
              fillColor="rgba(255,250,250, 0.1)" />
          </Section>

          <Section title="Temperature Statistics:" height="100px">
            <Chart.Line
              fillPositionedParent
              data={tempInputData}
              rangeX={[0, tempInputData.length - 1]}
              rangeY={[-273.15, 1000]}
              strokeColor="rgba(127, 179, 255 , 1)"
              fillColor="rgba(127, 179, 255 , 0.1)" />
            <Chart.Line
              fillPositionedParent
              data={tempOutputdata}
              rangeX={[0, tempOutputdata.length - 1]}
              rangeY={[-273.15, 1000]}
              strokeColor="rgba(255, 0, 0 , 1)"
              fillColor="rgba(255, 0, 0 , 0.1)" />
          </Section>

        </Stack.Item>
      </Stack>
    </Section>
  );
};

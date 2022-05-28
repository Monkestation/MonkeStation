import { useBackend } from '../../backend';
import { Box, Button, Flex, Icon, LabeledList, Tooltip } from '../../components';

export const RecipeLookup = (props, context) => {
  const { recipe, bookmarkedReactions } = props;
  const { act, data } = useBackend(context);
  if (!recipe) {
    return (
      <Box>
        No reaction selected!
      </Box>
    );
  }

  const getReaction = type => {
    return data.master_reaction_list.filter(reaction => (
      reaction.type === type
    ));
  };

  const addBookmark = bookmark => {
    bookmarkedReactions.add(bookmark);
  };

  return (
    <LabeledList>
      <LabeledList.Item bold label="Recipe">
        <Icon name="circle" mr={1} color={recipe.reagentCol} />
        {recipe.name}
        <Button
          icon="arrow-left"
          ml={3}
          disabled={recipe.subReactIndex === 1}
          onClick={() => act('reduce_index', {
            type: recipe.name,
          })} />
        <Button
          icon="arrow-right"
          disabled={recipe.subReactIndex === recipe.subReactLen}
          onClick={() => act('increment_index', {
            type: recipe.name,
          })} />
        {bookmarkedReactions && (
          <Button
            icon="book"
            color="green"
            disabled={bookmarkedReactions.has(getReaction(recipe.type)[0])}
            onClick={() => {
              addBookmark(getReaction(recipe.type)[0]);
              act('update_ui');
            }} />
        )}
      </LabeledList.Item>
      {recipe.products && (
        <LabeledList.Item bold label="Products">
          {recipe.products.map(product => (
            <Button
              key={product.name}
              icon="vial"
              disabled={product.hasProduct}
              content={product.ratio + "u " + product.name}
              onClick={() => act('reagent_click', {
                type: product.type,
              })} />
          ))}
        </LabeledList.Item>
      )}
      <LabeledList.Item bold label="Reactants">
        {recipe.reactants.map(reactant => (
          <Box key={reactant.type}>
            <Button
              icon="vial"
              color={reactant.color}
              content={reactant.ratio + "u " + reactant.name}
              onClick={() => act('reagent_click', {
                type: reactant.type,
              })} />
            {!!reactant.tooltipBool && (
              <Button
                icon="flask"
                color="purple"
                tooltip={reactant.tooltip}
                tooltipPosition="right"
                onClick={() => act('find_reagent_reaction', {
                  type: reactant.type,
                })} />
            )}
          </Box>
        ))}
      </LabeledList.Item>
      {recipe.catalysts && (
        <LabeledList.Item bold label="Catalysts">
          {recipe.catalysts.map(catalyst => (
            <Box key={catalyst.type}>
              {catalyst.tooltipBool && (
                <Button
                  icon="vial"
                  color={catalyst.color}
                  content={catalyst.ratio + "u " + catalyst.name}
                  tooltip={catalyst.tooltip}
                  tooltipPosition={"right"}
                  onClick={() => act('reagent_click', {
                    type: catalyst.type,
                  })} />
              ) || (
                <Button
                  icon="vial"
                  color={catalyst.color}
                  content={catalyst.ratio + "u " + catalyst.name}
                  onClick={() => act('reagent_click', {
                    type: catalyst.type,
                  })} />
              )}
            </Box>
          ))}
        </LabeledList.Item>
      )}
      {recipe.reqContainer && (
        <LabeledList.Item bold label="Container">
          <Button
            color="transparent"
            textColor="white"
            tooltipPosition="right"
            content={recipe.reqContainer}
            tooltip="The required container for this reaction to occur in." />
        </LabeledList.Item>
      )}
      <LabeledList.Item bold label="Rate profile" width="10px">
        <Box
          height="50px"
          position="relative"
          style={{
            'background-color': 'black',
          }} />
        <Flex
          justify="space-between">
          <Flex.Item
            position="relative"
            textColor={recipe.isColdRecipe && "red"}>
            <Tooltip
              content={recipe.isColdRecipe
              + "The minimum temperature needed for this reaction to start."} />
            {recipe.isColdRecipe
              + recipe.tempMin + "K"}
          </Flex.Item>
        </Flex>
      </LabeledList.Item>
    </LabeledList>
  );
};

import { NtosWindow } from '../layouts';
import { RbmkStatsContent } from './RbmkStats';

export const NtosRbmkStats = (props, context) => {

  return (
    <NtosWindow
      resizable
      width={450}
      height={600}>
      <NtosWindow.Content scrollable>
        <RbmkStatsContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};


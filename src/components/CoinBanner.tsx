import { Text, View } from 'react-native';
import { globalStyles } from '../styles/GlobalStyles';
import { CoinBannerProps } from '../types/itemTypes';

const CoinBanner: React.FC<CoinBannerProps> = ({coins}) => {
  return (
    <>
      <View style={globalStyles.banner}>
        <Text style={globalStyles.bannerText}>Coins: {coins}</Text>
      </View>
    </>
  );
};

export default CoinBanner;
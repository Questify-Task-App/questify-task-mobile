import { CoinsProvider } from '@/src/hooks/usePersistentCoins';
import { layoutStyles } from '@/src/styles/LayoutStyles';
import { Ionicons } from '@expo/vector-icons';
import { createMaterialTopTabNavigator } from '@react-navigation/material-top-tabs';
import { withLayoutContext } from 'expo-router';
import { Text, View } from 'react-native';

const { Navigator } = createMaterialTopTabNavigator();
const MaterialTabs = withLayoutContext(Navigator);

const TabLayout = () => {
  console.log('TabLayout rendered');

  return (
    <CoinsProvider>
      <View style={layoutStyles.root}>
        <View style={layoutStyles.header}>
          <Text style={layoutStyles.headerText}>Questify Task</Text>
        </View>
        <MaterialTabs
          tabBarPosition="bottom"
          screenOptions={{
            tabBarShowIcon: true,
            tabBarShowLabel: true,
            tabBarIndicatorStyle: layoutStyles.tabBarIndicator,
            tabBarStyle: layoutStyles.tabBar,
            tabBarActiveTintColor: '#1976d2',
            tabBarInactiveTintColor: '#757575',
            tabBarLabelStyle: layoutStyles.tabBarLabel,
            tabBarItemStyle: layoutStyles.tabBarItem,
            swipeEnabled: true,
          }}
        >
          <MaterialTabs.Screen
            name="index"
            options={{
              title: 'Daily',
              tabBarIcon: ({ color, size }: { color: string; size: number }) => (
                <Ionicons name="calendar" size={size} color={color} />
              ),
            }}
          />
          <MaterialTabs.Screen
            name="tasks"
            options={{
              title: 'Tasks',
              tabBarIcon: ({ color, size }: { color: string; size: number }) => (
                <Ionicons name="checkmark-done" size={size} color={color} />
              ),
            }}
          />
          <MaterialTabs.Screen
            name="rewards"
            options={{
              title: 'Rewards',
              tabBarIcon: ({ color, size }: { color: string; size: number }) => (
                <Ionicons name="gift" size={size} color={color} />
              ),
            }}
          />
        </MaterialTabs>
      </View>
    </CoinsProvider>
  );
};

export default TabLayout;

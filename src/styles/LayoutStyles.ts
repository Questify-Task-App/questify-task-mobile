import { StyleSheet, Platform } from 'react-native';

export const layoutStyles = StyleSheet.create({
  root: {
    flex: 1,
    backgroundColor: '#fff',
  },
  header: {
    height: (Platform.OS === 'ios' ? 60 : 50) + 10,
    backgroundColor: '#1976d2',
    alignItems: 'center',
    justifyContent: 'center',
    borderBottomWidth: 1,
    borderBottomColor: '#e0e0e0',
    elevation: 2,
  },
  headerText: {
    color: '#fff',
    fontSize: 22,
    fontWeight: 'bold',
    letterSpacing: 1,
    textAlign: 'center',
  },
  tabBar: {
    backgroundColor: '#f5f5f5',
    borderTopWidth: 0.5,
    borderTopColor: '#e0e0e0',
    height: Platform.OS === 'ios' ? 60 : 54,
    paddingBottom: Platform.OS === 'ios' ? 10 : 4,
    paddingTop: 2,
    elevation: 8,
    flexDirection: 'row',
  },
  tabBarIndicator: {
    backgroundColor: '#1976d2',
    height: 3,
    borderRadius: 2,
    marginBottom: 2,
  },
  tabBarLabel: {
    fontWeight: '600',
    fontSize: 13,
    marginBottom: 0,
    letterSpacing: 0.5,
    textAlign: 'center',
    flex: 1,
  },
  tabBarItem: {
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    flex: 1,
    minWidth: 80,
  },
});
